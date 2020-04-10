//
//  SearchContactCell.swift
//  epam_messenger
//
//  Created by Maxim on 09.04.2020.
//

import UIKit
import Reusable
import Firebase

class SearchContactCell: UITableViewCell {

    var model: ContactModel!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        avatarImageView.image = #imageLiteral(resourceName: "Nathan-Tannar")
//        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
//    }
//    
//    func loadContact(_ contact: ContactModel) {
//        self.model = contact
//        localName.text = contact.localName
//        //userIdLabel.text = contactsModel.userId
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   // var delegate: ChatListCellDelegateProtocol? {
    //        didSet {
    //            setupUi()
    //        }
    //    }
    //
    //    internal var chat: ChatProtocol!
    //
    //    private func setupUi() {
    //        if case .chat(let title, _) = chat.type {
    //            titleLabel.text = title
    //        }
    //        setupAvatar()
    //    }
    //
    //    private func setupAvatar() {
    //        delegate?.chatData(chat.documentId!) { chatModel in
    //            if let chatModel = chatModel {
    //                self.avatarImage.sd_setSmallImage(with: chatModel.avatarRef, placeholderImage: #imageLiteral(resourceName: "logo"))
    //            }
    //        }
    //        avatarImage.layer.cornerRadius = avatarImage.bounds.width / 2
    //    }
    //
    //    override func awakeFromNib() {
    //        super.awakeFromNib()
    //        separatorInset.left = 54
    //    }
    
}
