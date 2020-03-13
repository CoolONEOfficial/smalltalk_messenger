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

protocol ChatListViewControllerProtocol {
}

class ChatListViewController: UIViewController {
    var viewModel: ChatListViewModelProtocol!
    
    var bindDataSource: FUIFirestoreTableViewDataSource! {
        didSet {
            tableView.dataSource = bindDataSource
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationItem()
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

            return cell
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
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func toggleEditMode(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Done" : "Edit"
        navigationController?.setToolbarHidden(!tableView.isEditing, animated: true)
    }
    
    @objc private func deleteSelectedChats() {
        
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
            
//            let cell = tableView.cellForRow(at: indexPath)!
//            cell.isSelected = false
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didSelectionChange()
    }
    
//    func tableView(tableView: UITableView,
//        editingStyleForRowAtIndexPath indexPath: NSIndexPath)
//        -> UITableViewCell.EditingStyle {
//
//            return UITableViewCell.EditingStyle.init(rawValue: 3)!
//    }
    
//    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
//        return indexPath
//    }
    
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath)!
//        cell.accessoryType = .none
//    }
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        self.setEditing(true, animated: true)
    }
    
//    func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
//        print("1234567891234568")
//    }
    
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
                    // TODO: delete message
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

extension ChatListViewController: ChatListViewControllerProtocol {}
