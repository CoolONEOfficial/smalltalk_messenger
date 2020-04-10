//
//  ContactsListCell.swift
//  epam_messenger
//
//  Created by Maxim on 25.03.2020.
//

import UIKit
import Reusable
import Firebase

class ContactCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var localName: UILabel!

    var model: ContactModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.image = #imageLiteral(resourceName: "Nathan-Tannar")
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }
    
    func loadContact(_ contact: ContactModel) {
        self.model = contact
        localName.text = contact.localName
        //userIdLabel.text = contactsModel.userId
    }
}
