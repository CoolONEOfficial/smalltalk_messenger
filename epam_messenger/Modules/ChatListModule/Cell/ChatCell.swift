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
    
    @IBOutlet private var avatar: AvatarView!
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
    
    // MARK: - Init
    
    private func setupUi() {
        switch chat.type {
        case .personalCorr, .savedMessages:
            setupSavedOrPersonalCorr()
        case .chat(let title, let adminId, let hexColor):
            setupChat(title, adminId, hexColor)
        }
        
        messageLabel.text = chat.lastMessage.previewText
        timestampLabel.text = chat.lastMessage.timestampText
    }
    
    private func setupChat(
        _ title: String,
        _ adminId: String,
        _ hexColor: String?
    ) {
        titleLabel.text = title
        senderLabel.isHidden = false
        messageLabel.numberOfLines = 1
        
        avatar.setup(
            withRef: chat.avatarRef,
            text: String(title.first ?? " "),
            color: UIColor(hexString: hexColor) ?? .accent
        )

        senderLabel.text = "..."
        delegate?.userData(
            chat.lastMessage.userId
        ) { user in
            let user = user ?? .deleted()
            self.senderLabel.text = user.name
        }
    }
    
    private func setupSavedOrPersonalCorr() {
        titleLabel.text = "..."
        senderLabel.isHidden = true
        messageLabel.numberOfLines = 2
        
        if let friendId = chat.friendId {
            delegate?.userData(friendId) { friendModel in
                let friendModel = friendModel ?? .deleted()
                
                self.avatar.setup(withUser: friendModel)
                
                self.titleLabel.text = friendModel.fullName
            }
        } else {
            avatar.setupBookmark()
            titleLabel.text = "Saved messages"
        }
    }
}
