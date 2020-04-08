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
    
    var searchDataSource: FUIFirestoreTableViewDataSource!
    
    let searchController = UISearchController(searchResultsController: nil)
    private var searchItems: [UserModel] = .init()
//    let viewController: UIViewController!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        //title = "Contacts"
        tableView.register(cellType: UsersListCell.self)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search contacts"
        tabBarController?.title = "Contacts"
        //tableView.tableHeaderView = searchController.searchBar
        tabBarController?.navigationItem.searchController = searchController
        //navigationItem.searchController = searchController
        definesPresentationContext = true
        
        bindDataSource = self.tableView.bind(
            toFirestoreQuery: viewModel.firestoreQuery()
        ) { tableView, indexPath, snapshot in
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UsersListCell.self)
            self.viewModel.didUsersListLoad(snapshot: snapshot, cell: cell)
            return cell
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tabBarController?.title = "Contacts"
//        tabBarController?.navigationItem.searchController = searchController
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        tabBarController?.navigationItem.searchController = nil
//    }
}

// MARK: - delete user from users list

extension UsersListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { _, _, complete in
            let cell = self.tableView.cellForRow(at: indexPath) as? UsersListCell
            self.db.collection("users").document(Auth.auth().currentUser!.uid).delete()// Auth.auth().currentUser.uid - for real user
            tableView.reloadData()
            complete(true)
        }
        
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

// MARK: - Search bar

extension UsersListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reload), object: nil)
        if searchController.searchBar.text?.isEmpty ?? true {
            if !bindDataSource.isEqual(tableView.dataSource) {
                bindDataSource.bind(to: tableView)
                tableView.reloadData()
            }
        } else {
            self.perform(#selector(reload), with: nil, afterDelay: 0.5)
        }
    }
    
    @objc func reload() {
        if bindDataSource.isEqual(tableView.dataSource) {
            bindDataSource.unbind()
        }
        tableView.dataSource = nil
        searchController.searchBar.isLoading = true
        viewModel.searchUsers(searchController.searchBar.text!) { users in
            if let users = users {
                self.searchItems = users
                if !(self.tableView.dataSource?.isEqual(self) ?? false) {
                    self.tableView.dataSource = self
                }
            } else {
                // TODO: handle error
            }
            self.searchController.searchBar.isLoading = false
            self.tableView.reloadData()
        }
    }
}

extension UsersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = searchItems[indexPath.row]
        cell.textLabel?.text = "\(item.name) \(item.surname)"
        return cell
    }
}

extension UsersListViewController: UsersListViewControllerProtocol {}
