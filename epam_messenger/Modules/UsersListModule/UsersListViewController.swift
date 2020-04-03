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

protocol UsersListViewControllerProtocol {
}

class UsersListViewController: UIViewController {
    
    var db: Firestore = {
        return Firestore.firestore()
    }()
    
    var viewModel: UsersListViewModelProtocol!
    
    var bindDataSource: FUIFirestoreTableViewDataSource! {
        didSet {
            tableView.dataSource = bindDataSource
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        title = "User's list"
        tableView.register(cellType: UsersListCell.self)
        
        bindDataSource = self.tableView.bind(
            toFirestoreQuery: viewModel.firestoreQuery()
        ) { tableView, indexPath, snapshot in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UsersListCell.self)
            self.viewModel.didUsersListLoad(snapshot: snapshot, cell: cell)
            return cell
        }
    }
}

extension UsersListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { _, _, complete in
            let cell = self.tableView.cellForRow(at: indexPath) as? UsersListCell
            self.db.collection("users").document(cell!.model.documentId).delete()
            tableView.reloadData()
            complete(true)
        }
        
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension UsersListViewController: UsersListViewControllerProtocol {}
