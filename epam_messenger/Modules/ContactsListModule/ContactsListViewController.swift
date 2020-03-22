//
//  ContactsListViewController.swift
//  epam_messenger
//
//  Created by Maxim on 13.03.2020.
//

import UIKit
import Firebase
import FirebaseUI
import CodableFirebase
import Reusable

protocol ContactsListViewControllerProtocol {
}

class ContactsListViewController: UIViewController {
    
    var viewModel: ContactsListViewModelProtocol!
    
    var bindDataSource: FUIFirestoreTableViewDataSource! {
        didSet {
            tableView.dataSource = bindDataSource
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        tableView.register(cellType: ContactsCell.self)
        
        bindDataSource = self.tableView.bind(
            toFirestoreQuery: viewModel.firestoreQuery()
        ) { tableView, indexPath, snapshot in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ContactsCell.self)
            self.viewModel.didContactLoad(snapshot: snapshot, cell: cell)
            return cell
        }
    }
}

extension ContactsListViewController: ContactsListViewControllerProtocol {}
