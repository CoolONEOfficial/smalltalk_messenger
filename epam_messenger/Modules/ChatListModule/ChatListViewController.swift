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
import InstantSearchClient

protocol ChatListViewControllerProtocol {
}

class ChatListViewController: UIViewController {
    
    // MARK: - Vars
    
    var viewModel: ChatListViewModelProtocol!
    let searchController = UISearchController(searchResultsController: nil)
    private var searchCollectionIndex: Index!
    private let searchQuery = Query()
    private var searchItems: [ChatModel] = .init()
    
    var bindDataSource: FUIFirestoreTableViewDataSource! {
        didSet {
            tableView.dataSource = bindDataSource
        }
    }
    var searchDataSource: FUIFirestoreTableViewDataSource!
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationItem()
        setupSearchController()
        didSelectionChange()
        setupAlgoliaSearch()
    }
    
    private func setupAlgoliaSearch() {
        let searchClient = Client(appID: "V6J5G69XKH", apiKey: "c4ef45194a085992c251be8be124e796")
        searchCollectionIndex = searchClient.index(withName: "chats")
        searchQuery.hitsPerPage = 20
        searchQuery.filters = "users = 0" // TODO: user id
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
            
            return cell
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by chats"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Edit mode
    
    private func setupNavigationItem() {
        let rightItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(toggleEditMode)
        )
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func toggleEditMode(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Done" : "Edit"
        navigationController?.setToolbarHidden(!tableView.isEditing, animated: true)
    }
    
    @objc private func deleteSelectedChats() {
        // TODO: delete selected chats
    }
    
    private func didSelectionChange() {
        let rowsSelected = tableView.indexPathsForSelectedRows != nil
        
        title = rowsSelected
            ? "Selected \(tableView.indexPathsForSelectedRows!.count) chats"
            : "Chats"
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let deleteButton = UIBarButtonItem(
            title: "Delete",
            style: .plain,
            target: self,
            action: nil
        )
        if rowsSelected {
            deleteButton.action = #selector(deleteSelectedChats)
        } else {
            deleteButton.isEnabled = false
        }
        
        setToolbarItems([spaceButton, deleteButton], animated: true)
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
    
}

extension ChatListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            didSelectionChange()
        } else {
            let snapshot = bindDataSource.items[indexPath.item]
            var data = snapshot.data() ?? [:]
            data["documentId"] = snapshot.documentID

            do {
                let chatModel = try FirestoreDecoder()
                    .decode(
                        ChatModel.self,
                        from: data
                )
                
                viewModel.goToChat(chatModel)
                
            } catch let err {
                debugPrint("error while parse chat model: \(err)")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didSelectionChange()
    }
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        self.setEditing(true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if let chatModel = chatAt(indexPath.item) {
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
                    // TODO: delete chat
                }
                
                return UIMenu(title: "", children: [delete])
            }
            return configuration
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let identifier = configuration.identifier as? String else { return }
        guard let itemIndex = Int(identifier) else { return }
        
        if let chatModel = chatAt(itemIndex) {
            animator.addCompletion {
                self.viewModel.goToChat(chatModel)
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
        
        searchQuery.query = searchController.searchBar.text
        searchCollectionIndex.search(searchQuery) { (content, error) in
            guard let content = content else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            guard let chats = content["hits"] as? [[String: Any]] else { return }
            
            self.searchItems = chats.map { record in
                var model = record
                model["documentId"] = record["objectID"]
                return try! JSONDecoder().decode(ChatModel.self, from: JSONSerialization.data(withJSONObject: model))
            }
            if !(self.tableView.dataSource?.isEqual(self) ?? false) {
                self.tableView.dataSource = self
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
        cell.textLabel?.text = searchItems[indexPath.row].name
        return cell
    }
}

extension ChatListViewController: ChatListViewControllerProtocol {}
