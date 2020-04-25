//
//  SearchMessageCell.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 03.04.2020.
//

import UIKit
import Reusable
import FirebaseAuth

class SearchMessageCell: UITableViewCell, NibReusable {

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
    
    internal var message: MessageProtocol!
    
    private func setupUi() {
        senderLabel.text = "..."
        avatar.reset()
        delegate?.getChatData(message.chatId!) { chatModel in
            if let chatModel = chatModel {
                self.didLoadChat(chatModel)
            }
        }
        messageLabel.text = message.previewText
        self.messageLabel.numberOfLines = 2
        senderLabel.isHidden = true
        timestampLabel.text = message.timestampText
    }
    
    private func didLoadChat(_ chatModel: ChatModel) {
        switch chatModel.type {
        case .savedMessages:
            self.titleLabel.text = "Saved messages"
            self.avatar.setupBookmark()
        case .personalCorr(let between):
            self.titleLabel.text = "..."
            delegate?.listenUserData(
                between.first(where: { Auth.auth().currentUser!.uid != $0 })!
            ) { userModel in
                if let userModel = userModel {
                    self.titleLabel.text = userModel.fullName
                    self.avatar.setup(withUser: userModel)
                }
            }
        case .chat(let chatData):
            self.titleLabel.text = chatData.title
            delegate?.listenUserData(message.userId) { userModel in
                if let userModel = userModel {
                    self.senderLabel.isHidden = false
                    self.senderLabel.text = userModel.fullName
                    self.messageLabel.numberOfLines = 1
                    
                    self.avatar.setup(
                        withChat: chatData,
                        avatarRef: chatModel.avatarRef
                    )
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorInset.left = 75
    }
    
}
