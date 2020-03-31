//
//  ContactsCell.swift
//  epam_messenger
//
//  Created by Maxim on 13.03.2020.
//

import UIKit
import Reusable

class ContactsCell: UITableViewCell, NibReusable {
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var surnameLabel: UILabel!
    @IBOutlet private var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.image = #imageLiteral(resourceName: "Nathan-Tannar")
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }
    
    func loadUserModel(_ userModel: UserModel) {
        nameLabel.text = userModel.name
        surnameLabel.text = userModel.surname
    }
}
