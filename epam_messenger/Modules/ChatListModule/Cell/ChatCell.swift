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
        case .personalCorr:
            setupPersonalCorr()
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
                self.avatar.setup(withUser: friendModel)
            } else {
                self.titleLabel.text = "Deleted user"
                self.avatar.setup(withPlaceholder: "✖╭╮✖", color: .gray)
            }
            
        }
    }
}
