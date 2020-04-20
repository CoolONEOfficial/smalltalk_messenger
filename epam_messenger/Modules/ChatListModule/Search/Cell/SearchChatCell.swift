//
//  SearchChatCell.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 03.04.2020.
//

import UIKit
import Reusable

class SearchChatCell: UITableViewCell, NibReusable {

    // MARK: - Outlets
    
    @IBOutlet var avatar: AvatarView!
    @IBOutlet var titleLabel: UILabel!
    
    // MARK: - Vars
    
    weak var delegate: ChatListCellDelegate? {
        didSet {
            setupUi()
        }
    }
    
    internal var chat: ChatProtocol!
    
    private func setupUi() {
        if case .chat(let title, _, _) = chat.type {
            titleLabel.text = title
        }
        setupAvatar()
    }
    
    private func setupAvatar() {
        delegate?.chatData(chat.documentId!) { chatModel in
            if let chatModel = chatModel, case .chat(let title, _, let hexColor) = self.chat.type {
                self.avatar.setup(
                    withRef: chatModel.avatarRef,
                    text: String(title.first!),
                    color: UIColor(hexString: hexColor)!
                )
            }
        }
        avatar.layer.cornerRadius = avatar.bounds.width / 2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorInset.left = 54
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
