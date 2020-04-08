//
//  ChatListTableViewDelegate.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 03.04.2020.
//

import UIKit

extension ChatListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return searchChatItems.count
        case 1:
            return searchMessageItems.count
        default:
            fatalError("Unknown section")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return searchChatItems.isEmpty
                ? nil : "CHATS"
        case 1:
            return searchMessageItems.isEmpty
                ? nil : "MESSAGES"
        default:
            fatalError("Unknown section")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        header.contentView.backgroundColor = .secondarySystemBackground
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SearchChatCell.self)
            
            let chatModel = searchChatItems[indexPath.row]
            cell.chat = chatModel
            cell.delegate = self
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SearchMessageCell.self)
            
            let messageModel = searchMessageItems[indexPath.row]
            cell.message = messageModel
            cell.delegate = self
            
            return cell
        default:
            fatalError("Unknown section")
        }
    }
}
