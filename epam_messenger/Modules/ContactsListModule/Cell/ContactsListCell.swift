//
//  ContactsListCell.swift
//  epam_messenger
//
//  Created by Maxim on 25.03.2020.
//

import UIKit
import Reusable
import Firebase

class ContactsListCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var localName: UILabel!
    


var model: ContactsListModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.image = #imageLiteral(resourceName: "Nathan-Tannar")
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }
    
    func loadContactsListModel(_ contactsModel: ContactsListModel) {
        self.model = contactsModel
        localName.text = contactsModel.localName
        //userIdLabel.text = contactsModel.userId
    }
}
