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
        switch self.chat.type {
        case .chat(let chatData):
            self.avatar.setup(
                withChat: chatData,
                avatarRef: chat.avatarRef
            )
            titleLabel.text = chatData.title
        case .personalCorr:
            self.delegate?.listenUserData(chat.friendId!) { [weak self] userModel in
                guard let self = self, let userModel = userModel else { return }
                self.avatar.setup(withUser: userModel)
                self.titleLabel.text = userModel.fullName
            }
        default: break
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorInset.left = 54
    }

}
