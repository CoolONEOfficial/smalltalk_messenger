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
        case .savedMessages:
            setupSavedMessages()
        case .personalCorr:
            setupPersonalCorr()
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
        
        avatar.setup(
            withChat: chatData,
            avatarRef: chatData.avatarPath != nil
                ? Storage.storage().reference(withPath: chatData.avatarPath!)
                : nil,
            cornerRadius: 28
        )
        
        senderLabel.text = "..."
        let userId = chat.lastMessage.userId
        delegate?.listenUserData(userId) { user in
            let user = user ?? .deleted(userId)
            self.senderLabel.text = user.name
        }
    }
    
    private func setupSavedMessages() {
        avatar.setupBookmark()
        titleLabel.text = "Saved messages"
        senderLabel.isHidden = true
        messageLabel.numberOfLines = 2
    }
    
    private func setupPersonalCorr() {
        titleLabel.text = chat.friendName!
        senderLabel.isHidden = true
        messageLabel.numberOfLines = 2
        
        let friendId = chat.friendId!
        delegate?.listenUserData(friendId) { friendModel in
            let friendModel = friendModel ?? .deleted(friendId)
            self.avatar.setup(withUser: friendModel)
        }
    }
}
