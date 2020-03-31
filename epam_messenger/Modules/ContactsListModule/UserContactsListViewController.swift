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
    
    var db: Firestore = {
        return Firestore.firestore()
    }()
    
    var viewModel: UserContactsListViewModelProtocol!
    
    var bindDataSource: FUIFirestoreTableViewDataSource! {
        didSet {
            tableView.dataSource = bindDataSource
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        title = "Contacts"
        tableView.register(cellType: UserContactsListCell.self)
        
        bindDataSource = self.tableView.bind(
            toFirestoreQuery: viewModel.firestoreUserContactsListQuery()
        ) { tableView, indexPath, snapshot in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UserContactsListCell.self)
            self.viewModel.didUserContactsListLoad(snapshot: snapshot, cell: cell)
            let snapshot = self.bindDataSource.items[indexPath.row]
            return cell
        }
    }
    
}

extension UserContactsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { _, _, complete in
            let cell = self.tableView.cellForRow(at: indexPath) as? UserContactsListCell
            self.db.collection("users").document("7kEMVwxyIccl9bawojE3").collection("contacts").document("fB0OkG9ZI5a78SXLb5Fj").delete()
            tableView.reloadData()
            complete(true)
        }
        
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension UserContactsListViewController: UserContactsListViewControllerProtocol {}
