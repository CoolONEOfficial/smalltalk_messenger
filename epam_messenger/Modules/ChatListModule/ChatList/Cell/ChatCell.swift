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
        case .chat(let chatData):
            setup(withChat: chatData)
        }
        
        messageLabel.text = chat.lastMessage.previewText
        timestampLabel.text = chat.lastMessage.timestampText
    }
    
    private func setup(
        withChat chatData: (title: String, adminId: String, hexColor: String?, avatarPath: String?)
    ) {
        titleLabel.text = chatData.title
        senderLabel.isHidden = false
        messageLabel.numberOfLines = 1
        
        avatar.setup(withChat: chatData, avatarRef: chat.avatarRef)

        senderLabel.text = "..."
        let userId = chat.lastMessage.userId
        delegate?.userData(userId) { user in
            let user = user ?? .deleted(userId)
            self.senderLabel.text = user.name
        }
    }
    
    private func setupSavedOrPersonalCorr() {
        titleLabel.text = "..."
        senderLabel.isHidden = true
        messageLabel.numberOfLines = 2
        
        if let friendId = chat.friendId {
            delegate?.userData(friendId) { friendModel in
                let friendModel = friendModel ?? .deleted(friendId)
                
                self.avatar.setup(withUser: friendModel)
                
                self.titleLabel.text = friendModel.fullName
            }
        } else {
            avatar.setupBookmark()
            titleLabel.text = "Saved messages"
        }
    }
}
