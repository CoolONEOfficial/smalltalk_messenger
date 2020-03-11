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
        
        bindDataSource = self.tableView.bind(
            toFirestoreQuery: viewModel.firestoreQuery()
        ) { tableView, indexPath, snapshot in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ChatCell.self)
            
            if var chatModel = self.viewModel.didChatLoad(snapshot: snapshot, cell: cell) {
                snapshot.reference.collection("messages")
                    .order(by: "timestamp", descending: true)
                    .limit(to: 1)
                    .addSnapshotListener { messagesSnapshot, error in
                        guard let messages = messagesSnapshot else {
                            debugPrint("Error fetching messages: \(error!)")
                            return
                        }
                        
                        if let snapshot = messages.documents.first {
                            self.viewModel.didLastMessageLoad(
                                snapshot: snapshot,
                                cell: cell,
                                chatModel: &chatModel
                            )
                        }
                }
            }
            
            return cell
        }
    }
}

extension ChatListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.goToChat()
    }
    
}

extension ChatListViewController: ChatListViewControllerProtocol {}
