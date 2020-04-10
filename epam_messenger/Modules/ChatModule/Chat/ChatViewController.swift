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
    func presentPhotoViewer(_ storageRefs: [StorageReference], initialIndex: Int)
    func presentErrorAlert(_ text: String)
}

class ChatViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var floatingBottomButton: UIButton!
    
    // MARK: - Vars
    
    var defaultTitle = "..."
    
    var tableView: PaginatedSectionedTableView<Date, MessageModel>!
    
    var bottomScrollAnimationsLock = false
    
    let inputBar = ChatInputBar()
    var viewModel: ChatViewModelProtocol!
    var photosViewerCoordinator: ChatPhotoViewerDataSource!
    
    let titleStack = UIStackView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    let avatarImage = UIImageView()
    
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
        manager.bind(to: tableView)
        manager.on(event: .didShow) { [weak self] (notification) in
            guard let self = self else { return }
            
            self.keyboardHeight = notification.endFrame.height
            self.updateTableViewInset()
            
            if self.floatingBottomButton.isHidden {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.chat.loadInfo { title, subtitle in
            self.transitionSubtitleLabel {
                self.defaultTitle = title
                self.subtitleLabel.text = subtitle
                
                if !self.tableView.isEditing {
                    self.titleLabel.text = self.defaultTitle
                }
            }
        }
        
        titleLabel.text = defaultTitle
        view.tintColor = .accent
        
        setupTitle()
        setupAvatar()
        setupTableView()
        setupInputBar()
        setupEditModeButtons()
        setupFloatingBottomButton()
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
        updateTableViewInset()
        tableView.scrollToBottom()
    }
    
    // MARK: - Methods
    
    private func setupTitle() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .center
        
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        
        navigationItem.titleView = stackView
    }
    
    private func setupAvatar() {
        avatarImage.sd_setSmallImage(with: viewModel.chat.avatarRef, placeholderImage: #imageLiteral(resourceName: "logo"))
        avatarImage.size(.init(width: 40, height: 40))
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.layer.cornerRadius = 20
        avatarImage.clipsToBounds = true
        avatarImage.focusOnFaces = true
        avatarImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didAvatarTap)))
        avatarImage.hero.id = "avatar"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: avatarImage)
    }
    
    @objc func didAvatarTap() {
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
        tableView = .init(
            baseQuery: viewModel.baseQuery,
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
    
    func presentPhotoViewer(_ storageRefs: [StorageReference], initialIndex: Int) {
        var photosViewController: NYTPhotosViewController!
        
        if photosViewerCoordinator == nil || photosViewerCoordinator.data.count != storageRefs.count {
            photosViewerCoordinator = ChatPhotoViewerDataSource(
                data: storageRefs.enumerated().map { (index, ref) -> PhotoBox in
                    let photoBox = PhotoBox(ref.fullPath)
                    let cacheKey = "gs://\(ref.bucket)/\(ref.fullPath)"
                    
                    photoBox.image = SDImageCache.shared.imageFromDiskCache(forKey: cacheKey)
                    
                    if photoBox.image == nil {
                        ref.getData(maxSize: Int64.max) { data, err in
                            guard err == nil else {
                                debugPrint("Error while get image: \(err!.localizedDescription)")
                                return
                            }
                            
                            let image = UIImage(data: data!)
                            SDImageCache.shared.storeImage(toMemory: image, forKey: cacheKey)
                            photoBox.image = image
                            
                            photosViewController.updatePhoto(at: index)
                        }
                    }
                    
                    return photoBox
                }
            )
        }
        
        photosViewController = .init(
            dataSource: photosViewerCoordinator,
            initialPhotoIndex: initialIndex,
            delegate: self
        )
        
        present(photosViewController, animated: true)
    }
    
    func presentErrorAlert(_ text: String) {
        let alert = UIAlertController(title: "Error",
                                      message: text,
                                      preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ChatViewController: NYTPhotosViewControllerDelegate {
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, referenceViewFor photo: NYTPhoto) -> UIView? {
        guard let box = photo as? PhotoBox else { return nil }
        
        for (sectionIndex, day) in tableView.data.enumerated() {
            for (rowIndex, message) in day.elements.enumerated() {
                for (contentIndex, content) in message.kind.enumerated() {
                    switch content {
                    case .image(let path, _):
                        if box.path == path {
                            if let cell = tableView.cellForRow(at: .init(row: rowIndex, section: sectionIndex)) as? MessageCell {
                                let imageContent = cell.contentStack.subviews[contentIndex] as! MessageImageContent
                                return imageContent.imageView
                            } else {
                                presentErrorAlert("Image not found")
                            }
                        }
                    default: break
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