//
//  ChatDetailsUsersViewController.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 10.04.2020.
//

import UIKit
import XLPagerTabStrip
import FirebaseAuth

class ChatDetailsUsersViewController: UITableViewController {
    
    // MARK: - Vars
    
    var chat: ChatProtocol? {
        didSet {
            tableView.animateRowChanges(oldData: oldValue?.users ?? [], newData: chat?.users ?? [])
        }
    }
    var router: RouterProtocol?
    
    let firestoreService: FirestoreServiceProtocol = FirestoreService()
    
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
        if case .chat(_, let adminId, _, _) = chat!.type {
            completion = { user in
                cell.valueLabel.text = user?.documentId == adminId ? "admin" : nil
            }
        } else {
            completion = nil
        }
        cell.loadUser(byId: chat!.users[indexPath.row], completion: completion)
        let interaction = UIContextMenuInteraction(delegate: self)
        
        cell.addInteraction(interaction)
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectRow(sender:))))
        return cell
    }
    
    @objc func didSelectRow(sender: UITapGestureRecognizer) {
        let cell = sender.view as! UserCell
        
        if let user = cell.user,
            let userId = user.documentId,
            !user.deleted,
            userId != Auth.auth().currentUser?.uid,
            let router = router as? ChatRouter {
            router.showChatDetails(userId, from: nil, heroAnimations: false)
        }
    }
}

extension ChatDetailsUsersViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        let user = interaction.view as! UserCell
        let userId = user.user!.documentId!
        let identifier = "\(userId)" as NSString
        
        guard case .chat(_, let adminId, _, _) = chat!.type,
            adminId == Auth.auth().currentUser!.uid,
            userId != Auth.auth().currentUser!.uid else { return nil }
        
        return UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: nil) { _ in
                
                let kickAction = UIAction(
                    title: "Kick",
                    image: UIImage(systemName: "person.badge.minus")) { [weak self] _ in
                        guard let self = self,
                            let chat = self.chat else { return }
                        
                        self.firestoreService.kickChatUser(chatId: chat.documentId, userId: userId)
                        
                }
                
                return UIMenu(title: "", image: nil, children: [kickAction])
        }
    }
    
}

extension ChatDetailsUsersViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        .init(stringLiteral: "Users")
    }
}
