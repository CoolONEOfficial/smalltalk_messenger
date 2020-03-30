//
//  ChatCell.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import UIKit
import Reusable

class ChatCell: UITableViewCell, NibReusable {

    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var chatNameLabel: UILabel!
    @IBOutlet private var senderNameLabel: UILabel!
    @IBOutlet private var lastMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        chatNameLabel.isHidden = true
        avatarImageView.image = #imageLiteral(resourceName: "Nathan-Tannar")
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }
    
    func loadChatModel(
        _ chatModel: ChatModel
    ) {
        if chatModel.users.count > 2 {
            chatNameLabel.isHidden = false
            loadGroupChatData(
                chatName: chatModel.name,
                lastMessage: chatModel.lastMessage ?? MessageModel.empty()
            )
        } else {
            chatNameLabel.isHidden = true
            loadChatData(
                lastMessage: chatModel.lastMessage ?? MessageModel.empty()
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
        senderNameLabel.text = String(lastMessage.userId) // load user name
        var imageCount = 0
        var allText = ""
        var icon = ""
        for mKind in lastMessage.kind {
            switch mKind {
            case .image(_):
                imageCount += 1
                icon = "🖼️"
            case .audio(_):
                icon = "🎵"
            case .text(let text):
                allText += text
            case .forward(_):
                allText += "↪️"
            }
        }
        lastMessageLabel.text = "\(imageCount > 1 ? "x\(imageCount)" : "") \(icon) \(allText)"
        
    }
}
