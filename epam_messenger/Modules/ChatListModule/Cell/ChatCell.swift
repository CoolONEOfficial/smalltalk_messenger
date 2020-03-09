//
//  ChatCell.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import UIKit
import Reusable
import IGListKit

class ChatCell: UICollectionViewCell {

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var chatNameLabel: UILabel!
    @IBOutlet private var senderNameLabel: UILabel!
    @IBOutlet private var lastMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        chatNameLabel.isHidden = true
    }
    
    func loadChatModel(
        _ chatModel: ChatModel
    ) {
        if chatModel.users?.count ?? 0 > 2 {
            chatNameLabel.isHidden = false
            loadGroupChatData(
                chatName: chatModel.name ?? "",
                lastMessage: chatModel.lastMessage ?? MessageModel()
            )
        } else {
            chatNameLabel.isHidden = true
            loadChatData(
                lastMessage: chatModel.lastMessage ?? MessageModel()
            )
        }
    }
    
    private func loadGroupChatData(
        chatName: String,
        lastMessage: MessageModel
    ) {
        chatNameLabel.text = chatName
        loadChatData(lastMessage: lastMessage)
    }
    
    private func loadChatData(
        lastMessage: MessageModel
    ) {
        senderNameLabel.text = String(lastMessage.userId ?? 0) // load user name
        lastMessageLabel.text = lastMessage.text
    }

}
