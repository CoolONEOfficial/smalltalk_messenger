//
//  ContactsSearchDataSource.swift
//  epam_messenger
//
//  Created by Maxim on 09.04.2020.
//

import UIKit

extension ContactsListViewController: UITableViewDataSource {    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UserCell.self)
        let userModel = searchItems[indexPath.row]
        cell.loadUser(userModel)
        return cell
    }
}
