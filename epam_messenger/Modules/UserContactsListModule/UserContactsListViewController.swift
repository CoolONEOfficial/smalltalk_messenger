//
//  UserContactsListViewController.swift
//  epam_messenger
//
//  Created by Maxim on 25.03.2020.
//

import UIKit
import Firebase
import FirebaseUI
import CodableFirebase
import Reusable

protocol UserContactsListViewControllerProtocol {
}

class UserContactsListViewController: UIViewController {
    
    var viewModel: UserContactsListViewModelProtocol!
    
    var bindDataSource: FUIFirestoreTableViewDataSource! {
        didSet {
            tableView.dataSource = bindDataSource
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        tableView.register(cellType: UserContactsListCell.self)
        
        bindDataSource = self.tableView.bind(
            toFirestoreQuery: viewModel.firestoreUserContactsListQuery()
        ) { tableView, indexPath, snapshot in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UserContactsListCell.self)
            self.viewModel.didUserContactsListLoad(snapshot: snapshot, cell: cell)
            return cell
        }
    }
}

extension UserContactsListViewController: UserContactsListViewControllerProtocol {}
