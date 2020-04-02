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

protocol ChatCellDelegateProtocol {
    func userListData(
        _ userList: [String],
        completion: @escaping ([UserModel]?) -> Void
    )
}

class ChatCell: UITableViewCell, NibReusable {

    // MARK: - Outlets
    
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var senderNameLabel: UILabel!
    @IBOutlet private var lastMessageLabel: UILabel!
    
    // MARK: - Vars
    
    var delegate: ChatCellDelegateProtocol? {
        didSet {
            delegate?.userListData(
                chat.users.filter({ $0 != Auth.auth().currentUser?.uid })
            ) { userModelList in
                if let userModelList = userModelList {
                    switch self.chat.type {
                    case .personalCorr:
                        let friendModel = userModelList.first!
                        self.titleLabel.text = "\(friendModel.name) \(friendModel.surname)"
                    case .chat(let title, _):
                        self.titleLabel.text = title
                    }
                }
            }
        }
    }
    
    internal var chat: ChatModel! {
        didSet {
            titleLabel.isHidden = true
            switch chat.type {
            case .personalCorr:
                setupPersonalCorr()
            case .chat(let title, _):
                setupChat(title)
            }
        }
    }
    
    private func setupChat(
        _ title: String
    ) {
        titleLabel.text = title
        senderNameLabel.isHidden = false
        setupAvatar("chats/\(chat.documentId)/avatar.jpg")
    }
    
    private func setupPersonalCorr() {
        let friendId = chat.users.first(where: { $0 != Auth.auth().currentUser!.uid })!
        titleLabel.text = "..."
        senderNameLabel.isHidden = true
        setupAvatar("users/\(friendId)/avatar.jpg")
    }
    
    private func setupAvatar(_ path: String) {
        let avatarRef = Storage.storage().reference(withPath: path)
        avatarImageView.sd_setSmallImage(with: avatarRef, placeholderImage: #imageLiteral(resourceName: "logo"))
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }
    
    // MARK: - Init
    
    func loadChatModel(
        _ chatModel: ChatModel
    ) {
        self.chat = chatModel
    }
    
    private func loadGroupChatData(
        chatName: String,
        lastMessage: MessageModel
    ) {
        titleLabel.text = chatName
        loadChatData(lastMessage: lastMessage)
    }
    
    private func loadChatData(
        lastMessage: MessageModel
    ) {
        senderNameLabel.text = String(lastMessage.userId) // load user name
        var imageCount = 0
        var text = ""
        var attachmentText = ""
        var icon = ""
        for mKind in lastMessage.kind {
            switch mKind {
            case .image(_):
                imageCount += 1
                icon = "🖼️"
                attachmentText = "Image"
            case .audio(_):
                icon = "🎵"
                attachmentText = "Audio"
            case .text(let kindText):
                text += " \(kindText.prefix(10))..."
            case .forward(_):
                text += "Forwarded message"
            }
        }
        lastMessageLabel.text = "\(imageCount > 1 ? "x\(imageCount)" : "") \(icon) \(text.isEmpty ? attachmentText : text)"
        
    }
}
