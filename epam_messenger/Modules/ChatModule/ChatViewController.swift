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
    
    let primaryColor = UIColor(red: 87/255, green: 85/255, blue: 218/255, alpha: 1)
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: ChatTableView!
    
    // MARK: - Override ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.getChatModel().name
        
        tableView.register(cellType: MessageTextCell.self)
        tableView.dataSource = tableView.bind(
            toFirestoreQuery: viewModel.firestoreQuery()
        ) { tableView, indexPath in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MessageTextCell.self)
            
            cell.loadMessageModel(self.tableView.chatDataSource.messageItems[indexPath.section].value[indexPath.row])
            
            return cell
        }
    }
    
}
