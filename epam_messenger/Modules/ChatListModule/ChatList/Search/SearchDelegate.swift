//
//  ChatListSearchDelegate.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 03.04.2020.
//

import UIKit

extension ChatListViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reload), object: nil)
        if searchController.searchBar.text?.isEmpty ?? true {
            if !(tableView.dataSource?.isEqual(tableView) ?? true) {
                tableView.dataSource = tableView
                tableView.delegate = tableView
                self.tableView.separatorInset.left = 75
                tableView.reloadData()
                tableView.loadAtStart()
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
        
        let searchGroup = DispatchGroup()
        let searchText = searchController.searchBar.text!
        
        searchGroup.enter()
        viewModel.searchChats(searchText) { chats in
            if let chats = chats {
                self.searchChatItems = chats
            }
            searchGroup.leave()
        }
        
        searchGroup.enter()
        viewModel.searchMessages(searchText) { messages in
            if let messages = messages {
                self.searchMessageItems = messages

            }
            searchGroup.leave()
        }
        
        searchGroup.notify(queue: .main) {
            if !(self.tableView.dataSource?.isEqual(self) ?? false) {
                self.tableView.dataSource = self
                self.tableView.delegate = self
            }
            self.searchController.searchBar.isLoading = false
            self.tableView.separatorInset.left = 10
            self.tableView.reloadData()
        }
    }
    
}
