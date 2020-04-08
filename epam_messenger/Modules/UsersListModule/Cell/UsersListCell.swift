//
//  ContactsCell.swift
//  epam_messenger
//
//  Created by Maxim on 13.03.2020.
//

import UIKit
import Reusable

class UsersListCell: UITableViewCell, NibReusable {
    
    var model: UserModel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.image = #imageLiteral(resourceName: "Nathan-Tannar")
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }
    
    func loadUserModel(_ userModel: UserModel) {
        nameLabel.text = userModel.name
        surnameLabel.text = userModel.surname
        self.model = userModel
    }
}
