//
//  ChatTableViewDataSource.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import Foundation
import FirebaseUI

extension ChatViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MessageCell.self)

        let section = data[indexPath.section].elements
        let message = section[indexPath.row]

        cell.loadMessage(
            message,
            mergeNext: section.count > indexPath.row + 1
                && MessageModel.checkMerge(message, section[indexPath.row + 1]),
            mergePrev: 0 < indexPath.row
                && MessageModel.checkMerge(message, section[indexPath.row - 1])
        )
        cell.delegate = viewModel

        return cell
    }
    
    // MARK: - Helpers
    
    public func messageAt(_ indexPath: IndexPath) -> MessageModel {
        return data[indexPath.section].elements[indexPath.row]
    }
    
    public func dayAt(_ indexPath: IndexPath) -> Date {
        return dayAt(indexPath.section)
    }
    
    public func dayAt(_ section: Int) -> Date {
        return data[section].key
    }
}
