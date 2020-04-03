//
//  ContactsListViewController.swift
//  epam_messenger
//
//  Created by Maxim on 25.03.2020.
//

import UIKit
import Firebase
import FirebaseUI
import CodableFirebase
import Reusable

protocol ContactsListViewControllerProtocol {
}

class ContactsListViewController: UIViewController {
    
    var db: Firestore = {
        return Firestore.firestore()
    }()
    
    var viewModel: ContactsListViewModelProtocol!
    
    var bindDataSource: FUIFirestoreTableViewDataSource! {
        didSet {
            tableView.dataSource = bindDataSource
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        title = "Contacts"
        tableView.register(cellType: ContactsListCell.self)
        
        bindDataSource = self.tableView.bind(
            toFirestoreQuery: viewModel.firestoreContactsListQuery()
        ) { tableView, indexPath, snapshot in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ContactsListCell.self)
            self.viewModel.didContactsListLoad(snapshot: snapshot, cell: cell)
            //let snapshot = self.bindDataSource.items[indexPath.row]
            return cell
        }
    }
}

extension ContactsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { _, _, complete in
            let cell = self.tableView.cellForRow(at: indexPath) as? ContactsListCell
            self.db.collection("users").document("7kEMVwxyIccl9bawojE3").collection("contacts").document(cell!.model.userId).delete()
            tableView.reloadData()
            complete(true)
        }
        
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension ContactsListViewController: ContactsListViewControllerProtocol {}
