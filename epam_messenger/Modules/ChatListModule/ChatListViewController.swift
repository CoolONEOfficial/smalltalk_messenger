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

protocol ForwardDelegate: AnyObject {
    func didSelectChat(_ chatModel: ChatModel)
}

protocol ChatListCellDelegate: AnyObject {
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

let separatorInsetEdit: CGFloat = 120
let separatorInsetPlain: CGFloat = 75

class ChatListViewController: UIViewController {
    
    // MARK: - Vars
    
    var tableView: PaginatedTableView<ChatModel>!
    
    var viewModel: ChatListViewModelProtocol!
    let searchController = UISearchController(searchResultsController: nil)
    internal var searchChatItems = [ChatModel]()
    internal var searchMessageItems = [MessageModel]()
    
    weak var forwardDelegate: ForwardDelegate?
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupSearchController()
        setupNavigationItem()
        setupToolbarItems()
        didSelectionChange()
    }
    
    @objc func didCancelTap() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView = .init(
            baseQuery: viewModel.firestoreQuery(),
            initialPosition: .top,
            cellForRowAt: { indexPath in
                let cell = self.tableView.dequeueReusableCell(for: indexPath, cellType: ChatCell.self)
                let chatModel = self.tableView.elementAt(indexPath)
                
                cell.chat = chatModel
                cell.delegate = self
                
                return cell
            },
            querySideTransform: { chat in
                return chat.lastMessage.date
            },
            fromSnapshot: ChatModel.fromSnapshot
        )
        
        tableView.register(cellType: ChatCell.self)
        tableView.register(cellType: SearchChatCell.self)
        tableView.register(cellType: SearchMessageCell.self)
        tableView.paginatedDelegate = self
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.separatorInset.left = separatorInsetPlain
        tableView.sectionHeaderHeight = 20
        
        view.addSubview(tableView)
        tableView.edgesToSuperview()
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
        tableView.separatorInset.left = tableView.isEditing
            ? separatorInsetEdit
            : separatorInsetPlain
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
        viewModel.deleteSelectedChats(
            tableView.indexPathsForSelectedRows!.map { tableView.elementAt($0) }
        )
    }
    
    private func didSelectionChange() {
        let rowsSelected = tableView.indexPathsForSelectedRows != nil
        
        tabBarController?.title = rowsSelected
            ? "Selected \(tableView.indexPathsForSelectedRows!.count) chats"
            : "Chats"
        
        deleteButton.isEnabled = rowsSelected
    }
    
    // MARK: - Helpers
    
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
    
    var isSearch: Bool {
        return !(searchController.searchBar.text?.isEmpty ?? true)
    }
}

extension ChatListViewController: PaginatedTableViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    
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
    
    private func didSelect(_ chatModel: ChatModel?, _ indexPath: IndexPath) {
        if let chatModel = chatModel {
            if isForward {
                navigationController?.dismiss(animated: true) {
                    self.forwardDelegate?.didSelectChat(chatModel)
                }
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
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
            if isSearch {
                chatModel(at: indexPath) { chatModel in
                    self.didSelect(chatModel, indexPath)
                }
            } else {
                didSelect(self.tableView.elementAt(indexPath), indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didSelectionChange()
    }
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return !isForward && !isSearch
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        if !isForward && !isSearch {
            self.setEditing(true, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if !isForward, !isSearch {
            let identifier = NSString(string: String(indexPath.item))
            let chatModel = self.tableView.elementAt(indexPath)
            let configuration = UIContextMenuConfiguration(identifier: identifier, previewProvider: { () -> UIViewController? in
                // Return Preview View Controller here
                return self.viewModel.createChatPreview(chatModel)
            }) { _ -> UIMenu? in
                let delete = UIAction(
                    title: "Delete",
                    image: UIImage(systemName: "trash.fill"),
                    attributes: .destructive
                ) { _ in
                    self.viewModel.deleteSelectedChats([ chatModel ])
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
            
            let chatModel = self.tableView.elementAt(itemIndex)
            
            animator.addCompletion {
                self.viewModel.goToChat(chatModel)
            }
        }
    }
    
}

// MARK: - Cell delegate

extension ChatListViewController: ChatListCellDelegate {
    
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
