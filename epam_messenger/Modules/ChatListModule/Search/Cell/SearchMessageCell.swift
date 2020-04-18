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
    
    internal var message: MessageProtocol!
    
    private func setupUi() {
        senderLabel.text = "..."
        delegate?.chatData(message.chatId!) { chatModel in
            if let chatModel = chatModel {
                self.didLoadChat(chatModel)
            }
        }
        messageLabel.text = message.previewText
        self.messageLabel.numberOfLines = 2
        avatarImage.layer.cornerRadius = avatarImage.bounds.width / 2
        senderLabel.isHidden = true
        timestampLabel.text = message.timestampText
    }
    
    private func didLoadChat(_ chatModel: ChatModel) {
        switch chatModel.type {
        case .savedMessages, .personalCorr:
            self.titleLabel.text = "..."
            delegate?.userData(
                message.chatUsers!.first(where: { Auth.auth().currentUser!.uid != $0 })!
            ) { userModel in
                if let userModel = userModel {
                    self.titleLabel.text = userModel.fullName
                }
            }
        case .chat(let title, _, _):
            self.titleLabel.text = title
            delegate?.userData(message.userId) { userModel in
                if let userModel = userModel {
                    self.senderLabel.isHidden = false
                    self.senderLabel.text = userModel.fullName
                    self.messageLabel.numberOfLines = 1
                }
            }
        }
        self.avatarImage.sd_setSmallImage(with: chatModel.avatarRef, placeholderImage: #imageLiteral(resourceName: "logo"))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorInset.left = 75
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
