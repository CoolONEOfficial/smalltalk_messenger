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

class ChatViewController: UIViewController {
    
    // MARK: - Vars
    
    var viewModel: ChatViewModelProtocol!
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: ChatTableView!
    
    // MARK: - Override ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.getChatModel().name
        
        tableView.register(cellType: MessageCell.self)
        tableView.delegate = self
        tableView.dataSource = tableView.bind(
            toFirestoreQuery: viewModel.firestoreQuery()
        ) { tableView, indexPath in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MessageCell.self)
            
            let section = self.tableView
                .chatDataSource
                .messageItems[indexPath.section].value
            let message = section[indexPath.row]
            
            cell.mergeNext = section.count > indexPath.row + 1
                && section[indexPath.row + 1].userId == message.userId
            cell.loadMessage(message)
            
            return cell
        }
    }
    
}
