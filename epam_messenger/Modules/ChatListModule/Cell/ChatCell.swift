//
//  ChatCell.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import UIKit
import Reusable
import FirebaseAuth
import FirebaseStorage

class ChatCell: UITableViewCell, NibReusable {

    // MARK: - Outlets
    
    @IBOutlet private var avatarImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var senderLabel: UILabel!
    @IBOutlet private var messageLabel: UILabel!
    @IBOutlet private var timestampLabel: UILabel!
    
    // MARK: - Vars
    
    weak var delegate: ChatListCellDelegate? {
        didSet {
            setupUi()
        }
    }
    
    internal var chat: ChatModel!
    
    private func setupUi() {
        switch chat.type {
        case .personalCorr:
            setupPersonalCorr()
        case .chat(let title, _):
            setupChat(title)
        }
        messageLabel.text = chat.lastMessage.previewText
        setupAvatar()
        timestampLabel.text = chat.lastMessage.timestampText
    }
    
    private func setupChat(
        _ title: String
    ) {
        titleLabel.text = title
        senderLabel.isHidden = false
        messageLabel.numberOfLines = 1
        
        senderLabel.text = "..."
        delegate?.userData(
            chat.lastMessage.userId
        ) { userModel in
            if let userModel = userModel {
                self.senderLabel.text = userModel.name
            }
        }
    }
    
    private func setupPersonalCorr() {
        titleLabel.text = "..."
        senderLabel.isHidden = true
        messageLabel.numberOfLines = 2
        
        delegate?.userData(
            chat.users.filter({ $0 != Auth.auth().currentUser!.uid }).first!
        ) { friendModel in
            if let friendModel = friendModel {
                self.titleLabel.text = friendModel.fullName
            } else {
                self.titleLabel.text = "Deleted user"
            }
        }
    }
    
    private func setupAvatar() {
        avatarImage.sd_setSmallImage(with: chat.avatarRef, placeholderImage: #imageLiteral(resourceName: "logo"))
        avatarImage.layer.cornerRadius = avatarImage.bounds.width / 2
    }
}
