//
//  ChatDetailsUsersViewController.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 10.04.2020.
//

import UIKit
import XLPagerTabStrip

class ChatDetailsUsersViewController: UITableViewController {
    
    // MARK: - Vars
    
    var chat: ChatProtocol? {
        didSet {
            tableView.animateRowChanges(oldData: oldValue?.users ?? [], newData: chat?.users ?? [])
        }
    }
    
    // MARK: - Init
    
    override func viewDidLoad() {
        tableView.register(cellType: UserCell.self)
        tableView.backgroundView = .init()
        tableView.backgroundColor = .clear
        view.backgroundColor = .clear
    }
    
    func updateData(_ chat: ChatProtocol) {
        self.chat = chat
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chat?.users.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UserCell.self)
        let completion: ((UserModel?) -> Void)?
        if case .chat(_, let adminId, _) = chat!.type {
            completion = { user in
                cell.valueLabel.text = user?.documentId == adminId ? "admin" : nil
            }
        } else {
            completion = nil
        }
        cell.loadUser(byId: chat!.users[indexPath.row], completion: completion)
        return cell
    }
}

extension ChatDetailsUsersViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        .init(stringLiteral: "Users")
    }
}
