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
    
    // MARK: - Vars
    
    var db: Firestore = {
        return Firestore.firestore()
    }()
    
    var viewModel: ContactsListViewModelProtocol!
    
    var tableView: PaginatedSectionedTableView<String, ContactModel>!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView = .init(
            baseQuery: viewModel.baseQuery,
            initialPosition: .top,
            cellForRowAt: { indexPath in
                let cell = self.tableView.dequeueReusableCell(for: indexPath, cellType: ContactCell.self)

                let section = self.tableView.data[indexPath.section].elements
                let contact = section[indexPath.row]

                cell.loadContact(contact)

                return cell
            },
            querySideTransform: { contact in
                contact.localName
            },
            groupingBy: { contact in
                String(contact.localName.prefix(1))
            },
            sortedBy: { l, r in
                l > r
            },
            fromSnapshot: ContactModel.fromSnapshot
        )
//        self.tableView = .init(
//            baseQuery: viewModel.baseQuery,
//            initialPosition: .top,
//            cellForRowAt: { indexPath -> UITableViewCell in
//                let cell = self.tableView.dequeueReusableCell(for: indexPath, cellType: MessageCell.self)
//
//                let section = self.tableView.data[indexPath.section].elements
//                let message = section[indexPath.row]
//
//                cell.loadMessage(
//                    message,
//                    mergeNext: section.count > indexPath.row + 1
//                        && MessageModel.checkMerge(message, section[indexPath.row + 1]),
//                    mergePrev: 0 < indexPath.row
//                        && MessageModel.checkMerge(message, section[indexPath.row - 1])
//                )
//                cell.delegate = self.viewModel
//
//                return cell
//            },
//            querySideTransform: { message in
//                message.date
//            },
//            groupingBy: { message in
//                message.date.midnight
//            },
//            sortedBy: { l, r in
//                l.compare(r) == .orderedAscending
//            },
//            fromSnapshot: MessageModel.fromSnapshot
//        )
        tableView.register(cellType: ContactCell.self)
        tableView.paginatedDelegate = self
        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.edgesToSuperview()
    }
}

extension ContactsListViewController: PaginatedTableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { _, _, complete in
            let cell = self.tableView.cellForRow(at: indexPath) as? ContactCell
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
