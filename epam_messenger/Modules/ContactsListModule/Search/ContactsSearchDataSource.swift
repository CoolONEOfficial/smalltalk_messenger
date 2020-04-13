//
//  ContactsSearchDataSource.swift
//  epam_messenger
//
//  Created by Maxim on 09.04.2020.
//

import UIKit

extension ContactsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UserCell.self)
        let item = searchItems[indexPath.row]
        cell.titleLabel?.text = "\(item.name)"
        cell.subtitleLabel?.text = "\(item.surname)"
        return cell
    }
}
