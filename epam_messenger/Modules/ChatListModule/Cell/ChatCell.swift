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
    func userData(
        _ userId: String,
        completion: @escaping (UserModel?) -> Void
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
        setupLastMessage()
    }
    
    private func setupChat(
        _ title: String
    ) {
        titleLabel.text = title
        senderNameLabel.isHidden = false
        setupAvatar("chats/\(chat.documentId)/avatar.jpg")
        lastMessageLabel.numberOfLines = 1
        
        senderNameLabel.text = "..."
        delegate?.userData(
            chat.lastMessage.userId
        ) { userModel in
            if let userModel = userModel {
                self.senderNameLabel.text = userModel.name
            }
        }
    }
    
    private func setupPersonalCorr() {
        titleLabel.text = "..."
        senderNameLabel.isHidden = true
        setupAvatar("users/\(chat.friendId!)/avatar.jpg")
        lastMessageLabel.numberOfLines = 2
        
        delegate?.userData(
            chat.users.filter({ $0 != Auth.auth().currentUser!.uid }).first!
        ) { friendModel in
            if let friendModel = friendModel {
                self.titleLabel.text = "\(friendModel.name) \(friendModel.surname)"
            }
        }
    }
    
    private func setupAvatar(_ path: String) {
        let avatarRef = Storage.storage().reference(withPath: path)
        avatarImageView.sd_setSmallImage(with: avatarRef, placeholderImage: #imageLiteral(resourceName: "logo"))
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }
    
    private func setupLastMessage() {
        var imageCount = 0
        var text = ""
        var attachmentText = ""
        var icon = ""
        for mKind in chat.lastMessage.kind {
            switch mKind {
            case .image(_):
                imageCount += 1
                icon = "🖼️ "
                attachmentText = "Image"
            case .audio(_):
                icon = "🎵 "
                attachmentText = "Audio"
            case .text(let kindText):
                text = kindText
            case .forward(_): break
            }
        }
        lastMessageLabel.text = "\(imageCount > 1 ? "x\(imageCount) " : "")\(icon)\(text.isEmpty ? attachmentText : text)"
    }
    
    // MARK: - Init
    
    func loadChatModel(
        _ chatModel: ChatModel
    ) {
        self.chat = chatModel
    }
}
