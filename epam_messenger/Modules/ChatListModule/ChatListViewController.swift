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

protocol ChatListViewControllerProtocol {
}

class ChatListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Vars
    
    var viewModel: ChatListViewModelProtocol!
    let searchController = UISearchController(searchResultsController: nil)
    private var searchItems: [ChatModel] = .init()
    
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
        }
        
        setupTableView()
        setupNavigationItem()
        setupSearchController()
        setupToolbarItems()
        didSelectionChange()
    }
    
    private func setupTableView() {
        tableView.register(cellType: ChatCell.self)
        tableView.delegate = self
        
        bindDataSource = self.tableView.bind(
            toFirestoreQuery: viewModel.firestoreQuery()
        ) { tableView, indexPath, snapshot in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ChatCell.self)
            
            if let chatModel = self.chatFrom(snapshot) {
                cell.loadChatModel(chatModel)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            didSelectionChange()
        } else {
            let chatModel = (searchController.searchBar.text?.isEmpty ?? true)
                ? ChatModel.fromSnapshot(bindDataSource.items[indexPath.item])
                : searchItems[indexPath.item]
            
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

// MARK: - Search bar

extension ChatListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reload), object: nil)
        if searchController.searchBar.text?.isEmpty ?? true {
            if !bindDataSource.isEqual(tableView.dataSource) {
                bindDataSource.bind(to: tableView)
                tableView.reloadData()
            }
        } else {
            self.perform(#selector(reload), with: nil, afterDelay: 0.5)
        }
    }
    
    @objc func reload() {
        if bindDataSource.isEqual(tableView.dataSource) {
            bindDataSource.unbind()
        }
        tableView.dataSource = nil
        searchController.searchBar.isLoading = true
        viewModel.searchChats(searchController.searchBar.text!) { chats in
            if let chats = chats {
                self.searchItems = chats
                if !(self.tableView.dataSource?.isEqual(self) ?? false) {
                    self.tableView.dataSource = self
                }
            }
            self.searchController.searchBar.isLoading = false
            self.tableView.reloadData()
        }
    }
    
}

extension ChatListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let chatModel = searchItems[indexPath.row]
        
        let cellTitle: String
        if case .chat(let title, _) = chatModel.type {
            cellTitle = title
        } else {
            cellTitle = "..."
        }
        
        cell.textLabel?.text = cellTitle
        return cell
    }
}

// MARK: - Cell delegate

extension ChatListViewController: ChatCellDelegateProtocol {
    
    func userData(_ userId: String, completion: @escaping (UserModel?) -> Void) {
        viewModel.userData(userId, completion: completion)
    }
    
    func userListData(_ userList: [String], completion: @escaping ([UserModel]?) -> Void) {
        viewModel.userListData(userList, completion: completion)
    }
    
}

extension ChatListViewController: ChatListViewControllerProtocol {}
