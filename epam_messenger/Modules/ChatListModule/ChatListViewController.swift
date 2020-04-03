//
//  ChatListViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import UIKit
import Firebase
import FirebaseUI
import CodableFirebase
import Reusable

protocol ForwardDelegateProtocol {
    func didSelectChat(_ chatModel: ChatModel)
}

protocol ChatListCellDelegateProtocol {
    func userListData(
        _ userList: [String],
        completion: @escaping ([UserModel]?) -> Void
    )
    func userData(
        _ userId: String,
        completion: @escaping (UserModel?) -> Void
    )
    func chatData(
        _ chatId: String,
        completion: @escaping (ChatModel?) -> Void
    )
}

protocol ChatListViewControllerProtocol {
}

class ChatListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Vars
    
    var viewModel: ChatListViewModelProtocol!
    let searchController = UISearchController(searchResultsController: nil)
    internal var searchChatItems = [ChatModel]()
    internal var searchMessageItems = [MessageModel]()
    
    var forwardDelegate: ForwardDelegateProtocol?
    
    var bindDataSource: FUIFirestoreTableViewDataSource! {
        didSet {
            tableView.dataSource = bindDataSource
        }
    }
    var searchDataSource: FUIFirestoreTableViewDataSource!
    
    lazy var deleteButton: UIBarButtonItem = {
        return UIBarButtonItem(
            title: "Delete",
            style: .plain,
            target: self,
            action: #selector(deleteSelectedChats)
        )
    }()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isForward {
            title = "Forward"
            let backItem = UIBarButtonItem()
            backItem.title = "Cancel"
            backItem.tintColor = .accent
            backItem.action = #selector(didCancelTap)
            backItem.target = self
            navigationItem.leftBarButtonItem = backItem
        }
        
        setupTableView()
        setupNavigationItem()
        setupSearchController()
        setupToolbarItems()
        didSelectionChange()
    }
    
    @objc func didCancelTap() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.register(cellType: ChatCell.self)
        tableView.register(cellType: SearchChatCell.self)
        tableView.register(cellType: SearchMessageCell.self)
        tableView.delegate = self
        
        bindDataSource = self.tableView.bind(
            toFirestoreQuery: viewModel.firestoreQuery()
        ) { tableView, indexPath, snapshot in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ChatCell.self)
            
            if let chatModel = self.chatFrom(snapshot) {
                cell.chat = chatModel
            }
            cell.delegate = self
            
            return cell
        }
    }
    
    private func setupToolbarItems() {
        tabBarController?.setToolbarItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            deleteButton
        ], animated: false)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by chats"
        searchController.navigationItem.rightBarButtonItem?.tintColor = .red
        if isForward {
            navigationItem.searchController = searchController
        } else {
            tabBarController?.navigationItem.searchController = searchController
        }
    }
    
    // MARK: - Edit mode
    
    private func setupNavigationItem() {
        let rightItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(toggleEditMode)
        )
        tabBarController?.navigationItem.setRightBarButton(rightItem, animated: false)
    }
    
    @objc private func toggleEditMode(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        tableView.separatorInset.left = tableView.isEditing ? 120 : 75
        sender.title = tableView.isEditing ? "Done" : "Edit"
        
        setToolbarHidden(!tableView.isEditing)
        self.setTabBarHidden(tableView.isEditing)
    }
    
    private func setToolbarHidden(_ isHidden: Bool, completion: @escaping () -> Void = {}) {
        UIView.animate(withDuration: 0.3, animations: {
            self.tabBarController?.navigationController?.setToolbarHidden(!self.tableView.isEditing, animated: true)
        }, completion: { _ in
            completion()
        })
    }
    
    @objc private func deleteSelectedChats() {
        for indexPath in tableView.indexPathsForSelectedRows! {
            let chatModel = ChatModel.fromSnapshot(bindDataSource.items[indexPath.row])!
            
            viewModel.deleteChat(chatModel)
        }
    }
    
    private func didSelectionChange() {
        let rowsSelected = tableView.indexPathsForSelectedRows != nil
        
        tabBarController?.title = rowsSelected
            ? "Selected \(tableView.indexPathsForSelectedRows!.count) chats"
            : "Chats"
        
        deleteButton.isEnabled = rowsSelected
    }
    
    // MARK: - Helpers
    
    private func chatAt(_ itemIndex: Int) -> ChatModel? {
        let snapshot = bindDataSource.items[itemIndex]
        return chatFrom(snapshot)
    }
    
    private func chatFrom(_ snapshot: DocumentSnapshot) -> ChatModel? {
        var data = snapshot.data() ?? [:]
        data["documentId"] = snapshot.documentID
        
        do {
            return try FirestoreDecoder()
                .decode(
                    ChatModel.self,
                    from: data
            )
        } catch let err {
            debugPrint("error while parse chat model: \(err)")
            return nil
        }
    }
    
    func setTabBarHidden(
        _ hidden: Bool,
        animated: Bool = true,
        duration: TimeInterval = 0.3,
        completion: @escaping () -> Void = {}
    ) {
        
        if animated,
            let tabbar = tabBarController?.tabBar {
            if !hidden {
                tabbar.isHidden = false
            }
            UIView.animate(withDuration: duration, animations: {
                tabbar.alpha = hidden ? 0.0 : 1.0
            }) { _ in
                completion()
                if hidden {
                    tabbar.isHidden = true
                }
            }
            return
        }
        self.tabBarController?.tabBar.isHidden = hidden
    }
    
    // MARK: - Helpers
    
    var isForward: Bool {
        return tabBarController == nil
    }
}

extension ChatListViewController: UITableViewDelegate {
    
    private func chatModel(
        at indexPath: IndexPath,
        completion: @escaping (ChatModel?) -> Void
    ) {
        switch indexPath.section {
        case 0:
            completion(searchChatItems[indexPath.item])
        case 1:
            let message = searchMessageItems[indexPath.item]
            viewModel.chatData(message.chatId!, completion: completion)
        default:
            fatalError("Unknown section")
        }
    }
    
    private func didSelect(_ chatModel: ChatModel?) {
        if let chatModel = chatModel {
            if isForward {
                navigationController?.dismiss(animated: true) {
                    self.forwardDelegate?.didSelectChat(chatModel)
                }
            } else {
                viewModel.goToChat(chatModel)
            }
        } else {
            debugPrint("Error while parse selected chat")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            didSelectionChange()
        } else {
            if searchController.searchBar.text?.isEmpty ?? true {
                didSelect(ChatModel.fromSnapshot(bindDataSource.items[indexPath.item]))
            } else {
                chatModel(at: indexPath) { chatModel in
                    self.didSelect(chatModel)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didSelectionChange()
    }
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return !isForward
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        if !isForward {
            self.setEditing(true, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if !isForward,
            let chatModel = chatAt(indexPath.item) {
            let identifier = NSString(string: String(indexPath.item))
            let configuration = UIContextMenuConfiguration(identifier: identifier, previewProvider: { () -> UIViewController? in
                // Return Preview View Controller here
                return self.viewModel.createChatPreview(chatModel)
            }) { _ -> UIMenu? in
                let delete = UIAction(
                    title: "Delete",
                    image: UIImage(systemName: "trash.fill"),
                    attributes: .destructive
                ) { _ in
                    self.viewModel.deleteChat(chatModel)
                }
                
                return UIMenu(title: "", children: [delete])
            }
            return configuration
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        if !isForward {
            guard let identifier = configuration.identifier as? String else { return }
            guard let itemIndex = Int(identifier) else { return }
            
            if let chatModel = chatAt(itemIndex) {
                animator.addCompletion {
                    self.viewModel.goToChat(chatModel)
                }
            }
        }
    }
    
}

// MARK: - Cell delegate

extension ChatListViewController: ChatListCellDelegateProtocol {
    
    func userData(_ userId: String, completion: @escaping (UserModel?) -> Void) {
        viewModel.userData(userId, completion: completion)
    }
    
    func userListData(_ userList: [String], completion: @escaping ([UserModel]?) -> Void) {
        viewModel.userListData(userList, completion: completion)
    }
    
    func chatData(_ chatId: String, completion: @escaping (ChatModel?) -> Void) {
        viewModel.chatData(chatId, completion: completion)
    }
    
}

extension ChatListViewController: ChatListViewControllerProtocol {}
