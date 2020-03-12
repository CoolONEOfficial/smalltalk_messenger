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
        
        title = "ChatList"
        tableView.register(cellType: ChatCell.self)
        tableView.delegate = self
        
        let rightItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(toggleEditMode)
        )
        self.navigationItem.rightBarButtonItem = rightItem
        
        bindDataSource = self.tableView.bind(
            toFirestoreQuery: viewModel.firestoreQuery()
        ) { tableView, indexPath, snapshot in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ChatCell.self)
            
            self.viewModel.didChatLoad(snapshot: snapshot, cell: cell)
            
            return cell
        }
    }
    
    @objc func toggleEditMode(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Done" : "Edit"
    }
    
}

extension ChatListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = bindDataSource.items[indexPath.item]
        
        if let chatModel = ChatModel.fromSnapshot(snapshot) {
            viewModel.goToChat(chatModel)
        }
    }
    
    private func chatAt(_ itemIndex: Int) -> ChatModel? {
        let snapshot = bindDataSource.items[itemIndex]
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
