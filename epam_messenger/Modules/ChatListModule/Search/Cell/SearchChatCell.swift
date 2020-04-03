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
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    // MARK: - Vars
    
    var delegate: ChatListCellDelegateProtocol? {
        didSet {
            setupUi()
        }
    }
    
    internal var chat: ChatProtocol!
    
    private func setupUi() {
        if case .chat(let title, _) = chat.type {
            titleLabel.text = title
        }
        setupAvatar()
    }
    
    private func setupAvatar() {
        delegate?.chatData(chat.documentId!) { chatModel in
            if let chatModel = chatModel {
                self.avatarImage.sd_setSmallImage(with: chatModel.avatarRef, placeholderImage: #imageLiteral(resourceName: "logo"))
            }
        }
        avatarImage.layer.cornerRadius = avatarImage.bounds.width / 2
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
