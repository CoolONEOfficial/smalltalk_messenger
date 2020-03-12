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
    func batchedArray(_ array: FUIBatchedArray, didUpdateWith diff: FUISnapshotArrayDiff<DocumentSnapshot>) {
        debugPrint("array : \(array)")
    }
    
    func batchedArray(_ array: FUIBatchedArray, willUpdateWith diff: FUISnapshotArrayDiff<DocumentSnapshot>) {
        debugPrint("array : \(array)")
    }
    
    func batchedArray(_ array: FUIBatchedArray, queryDidFailWithError error: Error) {
        debugPrint("array : \(array)")
    }
    
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

extension ChatListViewController: ChatListViewControllerProtocol {}
