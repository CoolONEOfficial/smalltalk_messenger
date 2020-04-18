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
    
    let searchController = UISearchController(searchResultsController: nil)
    internal var searchItems: [UserModel] = .init()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSearchController()
        tabBarController?.title = "Contacts"
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search contacts"
        tabBarController?.navigationItem.searchController = searchController
    }
    
    private func setupTableView() {
        tableView = .init(
            baseQuery: viewModel.baseQuery,
            initialPosition: .top,
            cellForRowAt: { indexPath in
                let cell = self.tableView.dequeueReusableCell(for: indexPath, cellType: UserCell.self)
                let contact = self.tableView.elementAt(indexPath)
                
                cell.loadUser(byId: contact.userId)
                
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
        
        tableView.register(cellType: UserCell.self)
        tableView.paginatedDelegate = self
        tableView.allowsMultipleSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.separatorInset.left = UserCell.separatorLeftInset
        
        view.addSubview(tableView)
        tableView.edgesToSuperview()
    }
}

extension ContactsListViewController: PaginatedTableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { _, _, complete in
            let contact = self.tableView.elementAt(indexPath)
            self.db.collection("users").document(Auth.auth().currentUser!.uid).collection("contacts").document(contact.documentId!).delete()
            tableView.reloadData()
            complete(true)
        }
        
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension ContactsListViewController: ContactsListViewControllerProtocol {}
