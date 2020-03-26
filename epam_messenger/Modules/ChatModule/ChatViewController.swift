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

protocol ChatViewControllerProtocol: AutoMockable {
    func presentPhotoViewer(_ storageRefs: [StorageReference], initialIndex: Int)
}

class ChatViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: ChatTableView!
    var bottomScrollAnimationsLock = false
    @IBOutlet var floatingBottomButton: UIButton!
    
    // MARK: - Vars
    
    let inputBar = ChatInputBar()
    var viewModel: ChatViewModelProtocol!
    var photosViewerCoordinator: ChatPhotoViewerDataSource!
    
    var deleteButton = UIButton()
    var forwardButton = UIButton()
    let stack = UIStackView()
    
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
        manager.on(event: .didChangeFrame) { [weak self] (notification) in
            self?.updateTableViewInset(notification.endFrame.height)
        }.on(event: .didHide) { [weak self] _ in
            self?.updateTableViewInset()
        }
        
        return manager
    }()
    
    typealias MessageAttachment = AttachmentManager.Attachment
    
    lazy var attachmentManager: AttachmentManager = { [unowned self] in
        let manager = AttachmentManager()
        manager.delegate = self
        manager.attachmentView.backgroundColor = .systemBackground
        manager.tintColor = .accent
        return manager
    }()
    
    // MARK: - Events
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.getChatModel().name
        view.tintColor = .accent
        
        setupTableView()
        setupInputBar()
        setupEditModeButtons()
        setupFloatingBottomButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateTableViewInset()
        tableView.scrollToBottom(animated: true)
    }
    
    // MARK: - Methods
    
    private func setupFloatingBottomButton() {
        floatingBottomButton.layer.cornerRadius = floatingBottomButton.bounds.width / 2
        floatingBottomButton.layer.borderWidth = 0.5
        floatingBottomButton.layer.borderColor = UIColor.plainBackground.cgColor
    }
    
    private func setupEditModeButtons() {
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.addArrangedSubview(deleteButton)
        stack.addArrangedSubview(forwardButton)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = .init(top: 5, leading: 10, bottom: 0, trailing: 10)
        
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
        inputBar.delegate = self
        _ = keyboardManager
        inputBar.inputPlugins = [autocompleteManager, attachmentManager]
    }
    
    private func setupTableView() {
        tableView.register(cellType: MessageCell.self)
        tableView.delegate = self
        tableView.messageDelegate = viewModel
        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        
        tableView.dataSource = tableView.bind(
            toFirestoreQuery: viewModel.firestoreQuery()
        ) { tableView, indexPath in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MessageCell.self)
            
            let section = self.tableView
                .chatDataSource
                .messageItems[indexPath.section].value
            let message = section[indexPath.row]
            
            cell.loadMessage(
                message,
                mergeNext: section.count > indexPath.row + 1
                    && MessageModel.checkMerge(left: message, right: section[indexPath.row + 1]),
                mergePrev: 0 < indexPath.row
                    && MessageModel.checkMerge(left: message, right: section[indexPath.row - 1])
            )
            
            return cell
        }
    }
    
    // MARK: - Helpers
    
    internal func updateTableViewInset(_ additional: CGFloat = 0) {
        let bottomSafeArea = view.safeAreaInsets.bottom
        let barHeight = inputBar.bounds.height
        tableView.contentInset.bottom = barHeight + additional - bottomSafeArea
        tableView.verticalScrollIndicatorInsets.bottom = barHeight + additional - bottomSafeArea
    }
    
    // MARK: Floating bottom button
    
    @IBAction func didFloatingBottomButtonClick(_ sender: UIButton) {
        tableView.scrollToBottom(animated: true)
    }
    
}

extension ChatViewController: ChatViewControllerProtocol {
    
    func presentPhotoViewer(_ storageRefs: [StorageReference], initialIndex: Int) {
        var photosViewController: NYTPhotosViewController!
        let coordinator = ChatPhotoViewerDataSource(
            data: storageRefs.map { ref -> PhotoBox in
                debugPrint("fullpath: \(ref.fullPath)")
                let photoBox = PhotoBox(ref.fullPath)
                
                ref.getData(maxSize: Int64.max) { data, err in
                    guard let data = data else {
                        debugPrint("error while get image data: \(err?.localizedDescription ?? "nil error")")
                        return
                    }
                    
                    photoBox.image = UIImage(data: data)
                    photosViewController.update(photoBox)
                }
                return photoBox
            }
        )
        
        photosViewerCoordinator = coordinator
        
        photosViewController = .init(
            dataSource: coordinator,
            initialPhotoIndex: initialIndex,
            delegate: self
        )
        
        present(photosViewController, animated: true)
    }
    
}

extension ChatViewController: NYTPhotosViewControllerDelegate {
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, referenceViewFor photo: NYTPhoto) -> UIView? {
        guard let box = photo as? PhotoBox else { return nil }

        let lastCellTapContent = viewModel.lastTapCellContent as! MessageImageContent
        return box.path == lastCellTapContent.imageMessage.kindImage(at: lastCellTapContent.kindIndex)?.path
            ? viewModel.lastTapCellContent
            : nil
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, maximumZoomScaleFor photo: NYTPhoto) -> CGFloat {
        return 2
    }
}
