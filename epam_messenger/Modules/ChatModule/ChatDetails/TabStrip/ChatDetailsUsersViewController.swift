//
//  ChatDetailsUsersViewController.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 10.04.2020.
//

import UIKit
import XLPagerTabStrip

class ChatDetailsUsersViewController: UITableViewController {
    var users: [String] = [] {
        didSet {
            tableView.animateRowChanges(oldData: oldValue, newData: users)
        }
    }
    
    override func viewDidLoad() {
        tableView.register(cellType: UserCell.self)
        tableView.isScrollEnabled = false
    }
    
    func updateData(_ users: [String]) {
        self.users = users
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100 //users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UserCell.self)
//        cell.loadUser(byId: users[indexPath.row])
        let d = UITableViewCell.init(style: .default, reuseIdentifier: nil)
        d.textLabel?.text = "\(indexPath.row)"
        return d //cell
    }
}

extension ChatDetailsUsersViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        .init(stringLiteral: "Users")
    }
}
