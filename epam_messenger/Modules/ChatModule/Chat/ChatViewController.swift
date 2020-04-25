//
//  ChatViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 08.03.2020.
//
import UIKit
import Firebase
import FirebaseUI
import CodableFirebase
import InputBarAccessoryView
import NYTPhotoViewer
import Differ
import Hero
import FaceAware

protocol ChatViewControllerProtocol: AutoMockable {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func presentErrorAlert(_ text: String)
    func didChatLoad()
    
    var defaultTitle: String { get set }
    var photosViewerDataSource: ChatPhotoViewerDataSource! { get set }
}

class ChatViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var floatingBottomButton: UIButton!
    
    // MARK: - Vars
    
    var viewModel: ChatViewModelProtocol!
    lazy var imagePickerService: ImagePickerServiceProtocol = {
        return ImagePickerService(viewController: self, cameraDevice: .rear)
    }()
    
    var defaultTitle = "..."
    
    var tableView: PaginatedSectionedTableView<Date, MessageModel>!
    
    var bottomScrollAnimationsLock = false
    
    let inputBar = ChatInputBar()
    var photosViewerDataSource: ChatPhotoViewerDataSource!
    
    let titleStack = UIStackView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    let avatar = AvatarView()
    
    var deleteButton = UIButton()
    var forwardButton = UIButton()
    let editStack = UIStackView()
    
    var forwardMessages: [MessageProtocol]!
    
    var keyboardHeight: CGFloat = 0
    
    var isTyping: Bool = false
    
    lazy var autocompleteManager: AutocompleteManager = { [unowned self] in
        let manager = AutocompleteManager(for: self.inputBar.inputTextView)
        
        manager.defaultTextAttributes[.foregroundColor] = UIColor.plainText
        self.inputBar.inputTextView.textColor = UIColor.plainText
        
        manager.delegate = self
        manager.dataSource = self
        
        return manager
    }()
    
    lazy var keyboardManager: KeyboardManager = { [unowned self] in
        let manager = KeyboardManager()
        
        manager.bind(inputAccessoryView: inputBar)
        if tableView != nil {
            manager.bind(to: tableView)
        }
        manager.on(event: .didShow) { [weak self] (notification) in
            guard let self = self else { return }
            
            self.keyboardHeight = notification.endFrame.height
            self.updateTableViewInset()
            
            if self.tableView != nil, self.floatingBottomButton.isHidden {
                self.tableView.scrollToBottom()
            }
        }.on(event: .didHide) { [weak self] _ in
            guard let self = self else { return }
            
            self.keyboardHeight = 0
            self.updateTableViewInset()
        }
        
        return manager
    }()
    
    typealias MessageAttachment = AttachmentManager.Attachment
    
    lazy var attachmentManager: AttachmentManager = { [unowned self] in
        let manager = AttachmentManager()
        manager.delegate = self
        manager.attachmentView.backgroundColor = .systemBackground
        manager.tintColor = .accent
        manager.showAddAttachmentCell = false
        return manager
    }()
    
    // MARK: - Events
    
    func didChatLoad() {
        setupAvatar()
        setupTableView()
        setupInputBar()
        viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = defaultTitle
        view.tintColor = .accent
        
        setupTitle()
        setupEditModeButtons()
        setupFloatingBottomButton()
        viewModel.viewDidLoad()
        
        viewModel.listenChatData { [weak self] _ in
            guard let self = self else { return }
            self.setupInfo()
        }
    }
    
    private func setupInfo() {
        viewModel.chat.listenInfo { [weak self] title, subtitle, placeholderText, placeholderColor in
            guard let self = self else { return }
            
            self.transitionSubtitleLabel {
                if title != "..." {
                    self.defaultTitle = title
                }
                self.subtitleLabel.text = subtitle
                
                if !(self.tableView?.isEditing ?? false) {
                    self.titleLabel.text = self.defaultTitle
                }
            }
            
            if let placeholderText = placeholderText {
                if let avatarRef = self.viewModel.chat.avatarRef {
                    self.avatar.setup(
                        withRef: avatarRef,
                        text: placeholderText,
                        color: placeholderColor,
                        cornerRadius: 20
                    )
                } else {
                    self.avatar.setup(
                        withPlaceholder: placeholderText,
                        color: placeholderColor,
                        cornerRadius: 20
                    )
                }
            }
        }
    }
    
    private func transitionSubtitleLabel(
        animations: (() -> Void)?
    ) {
        UIView.transition(
            with: self.subtitleLabel,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: animations,
            completion: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if tableView != nil && floatingBottomButton.isHidden {
            updateTableViewInset()
            tableView.scrollToBottom() // scroll to new inset
        }
    }
    
    // MARK: - Methods
    
    private func setupTitle() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.hero.id = "title"
        
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1
        subtitleLabel.hero.id = "subtitle"
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didNavigationItemsTap)))
        
        navigationItem.titleView = stackView
    }
    
    private func setupAvatar() {
        if viewModel.chat.type != .savedMessages {
            avatar.size(.init(width: 40, height: 40))
            avatar.addGestureRecognizer(UITapGestureRecognizer.init(
                target: self, action: #selector(didNavigationItemsTap)
            ))
            avatar.hero.id = "avatar"
            
            navigationItem.setRightBarButton(UIBarButtonItem(customView: avatar), animated: true)
        }
    }
    
    @objc func didNavigationItemsTap() {
        viewModel.goToDetails()
    }
    
    private func setupFloatingBottomButton() {
        floatingBottomButton.layer.cornerRadius = floatingBottomButton.bounds.width / 2
        floatingBottomButton.layer.borderWidth = 0.5
        floatingBottomButton.layer.borderColor = UIColor.plainBackground.cgColor
    }
    
    private func setupEditModeButtons() {
        editStack.axis = .horizontal
        editStack.alignment = .fill
        editStack.distribution = .equalSpacing
        editStack.addArrangedSubview(deleteButton)
        editStack.addArrangedSubview(forwardButton)
        editStack.isLayoutMarginsRelativeArrangement = true
        editStack.directionalLayoutMargins = .init(top: 5, leading: 10, bottom: 0, trailing: 10)
        
        deleteButton.contentHorizontalAlignment = .fill
        deleteButton.contentVerticalAlignment = .fill
        deleteButton.contentMode = .scaleAspectFit
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.addTarget(self, action: #selector(ChatViewController.deleteSelectedMessages), for: .touchUpInside)
        deleteButton.size(.init(width: 23, height: 25))
        
        forwardButton.contentHorizontalAlignment = .fill
        forwardButton.contentVerticalAlignment = .fill
        forwardButton.contentMode = .scaleAspectFit
        forwardButton.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        forwardButton.addTarget(self, action: #selector(ChatViewController.forwardSelectedMessages), for: .touchUpInside)
        forwardButton.size(.init(width: 30, height: 25))
    }
    
    private func setupInputBar() {
        view.addSubview(inputBar)
        floatingBottomButton.bottomToTop(of: inputBar, offset: -10)
        inputBar.delegate = self
        inputBar.chatDelegate = self
        _ = keyboardManager
        
        inputBar.inputPlugins = [autocompleteManager, attachmentManager]
    }
    
    private func setupTableView() {
        guard let baseQuery = viewModel.baseQuery else { return }
        
        tableView = .init(
            baseQuery: baseQuery,
            initialPosition: .bottom,
            cellForRowAt: { indexPath -> UITableViewCell in
                let cell = self.tableView.dequeueReusableCell(for: indexPath, cellType: MessageCell.self)
                
                let section = self.tableView.data[indexPath.section].elements
                let message = section[indexPath.row]
                
                cell.loadMessage(
                    message,
                    mergeNext: section.count > indexPath.row + 1
                        && MessageModel.checkMerge(message, section[indexPath.row + 1]),
                    mergePrev: 0 < indexPath.row
                        && MessageModel.checkMerge(message, section[indexPath.row - 1])
                )
                cell.delegate = self.viewModel
                
                return cell
            },
            querySideTransform: { message in
                message.date
            },
            groupingBy: { message in
                message.date.midnight
            },
            sortedBy: { l, r in
                l.compare(r) == .orderedAscending
            },
            fromSnapshot: MessageModel.fromSnapshot
        )
        tableView.register(cellType: MessageCell.self)
        tableView.paginatedDelegate = self
        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.edgesToSuperview()
        
        view.bringSubviewToFront(floatingBottomButton)
    }
    
    // MARK: - Helpers
    
    internal func updateTableViewInset(_ additional: CGFloat = 0) {
        guard tableView != nil else { return }
        
        let bottomSafeArea = view.safeAreaInsets.bottom
        let barHeight = inputBar.bounds.height
        let bottomInset =  barHeight + additional - bottomSafeArea + keyboardHeight
        
        UIView.animate(withDuration: 0.5) {
            self.tableView.contentInset.bottom = bottomInset
        }
        tableView.verticalScrollIndicatorInsets.bottom = bottomInset
    }
    
    internal func didStartSendMessage() {
        (inputBar.rightStackView.subviews.first as! InputBarSendButton).startAnimating()
        inputBar.inputTextView.text = String()
        inputBar.inputTextView.placeholder = "Sending..."
    }
    
    internal func didEndSendMessage() {
        inputBar.sendButton.stopAnimating()
        inputBar.voiceButton.stopAnimating()
        inputBar.inputTextView.placeholder = "Message..."
        inputBar.invalidatePlugins()
    }
    
    // MARK: Floating bottom button
    
    @IBAction func didFloatingBottomButtonClick(_ sender: UIButton) {
        if tableView.dataAtEnd {
            tableView.scrollToBottom()
        } else {
            tableView.loadAtEnd { messages in
                self.tableView.updateElements(messages, animate: false)
                self.tableView.scrollToBottom()
            }
        }
    }
    
}

extension ChatViewController: ChatViewControllerProtocol {
}

extension ChatViewController: NYTPhotosViewControllerDelegate {
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, referenceViewFor photo: NYTPhoto) -> UIView? {
        guard let box = photo as? PhotoBox else { return nil }
        
        for visibleCell in tableView.visibleCells {
            if let cell = visibleCell as? MessageCell {
                for (index, content) in cell.contentStack.subviews.enumerated() {
                    debugPrint("index: \(index)")
                    if let imageContent = content as? MessageImageContent {
                        let image = imageContent.imageMessage.kindImage(at: imageContent.kindIndex)

                        if image?.path == box.path {
                            let maskLayer = cell.makeBubbleMaskLayer(
                                top: !imageContent.mergeContentPrev,
                                bottom: !imageContent.mergeContentNext,
                                height: imageContent.frame.height
                            )
                            maskLayer.transform = CATransform3DMakeTranslation(
                                imageContent.message.isIncoming
                                    ? messageTailsInset
                                    : messageTailsInset * 2,
                                0,
                                0
                            )
                            imageContent.layer.mask = maskLayer
                            return content
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, maximumZoomScaleFor photo: NYTPhoto) -> CGFloat {
        return 2
    }
}
