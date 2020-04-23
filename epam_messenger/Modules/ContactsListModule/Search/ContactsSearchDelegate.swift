//
//  ContactsSearchDelegate.swift
//  epam_messenger
//
//  Created by Maxim on 09.04.2020.
//

import UIKit

extension ContactsListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reload), object: nil)
        if searchController.searchBar.text?.isEmpty ?? true {
            if let dataSource = tableView.dataSource,
                !dataSource.isEqual(tableView) {
                tableView.dataSource = tableView
                tableView.delegate = tableView
                tableView.reloadData()
            }
        } else {
            self.perform(#selector(reload), with: nil, afterDelay: 0.5)
        }
    }
    
    @objc func reload() {
        if tableView.isEqual(tableView.dataSource) {
            tableView.listener.remove()
        }
        tableView.dataSource = nil
        searchController.searchBar.isLoading = true
        
        viewModel.searchUsers(searchController.searchBar.text!) { users in
            if let users = users {
                self.searchItems = users
            }
            
            if !(self.tableView.dataSource?.isEqual(self) ?? false) {
                self.tableView.dataSource = self
                self.tableView.delegate = self
            }
            
            self.searchController.searchBar.isLoading = false
            self.tableView.reloadData()
        }
    }
}
