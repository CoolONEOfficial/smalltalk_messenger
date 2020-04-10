//
//  UserCell.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 10.04.2020.
//

import UIKit
import Reusable

class UserCell: UITableViewCell, NibReusable {

    // MARK: - Outlets
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    // MARK: - Vars
    
    var user: UserProtocol? {
        didSet {
            self.titleLabel.text = user?.fullName
            self.subtitleLabel.text = user?.onlineText
        }
    }
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAvatar()
    }
    
    private func setupAvatar() {
        avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
    }

    // MARK: - Methods
    
    func loadUser(_ user: UserProtocol, valueText: String? = nil) {
        self.user = user
        self.valueLabel.text = valueText
        avatarImage.sd_setSmallImage(with: user.avatarRef)
    }
    
    func loadUser(byId userId: String) {
        FirestoreService().userData(userId) { user in
            self.user = user
        }
        avatarImage.sd_setSmallImage(with: UserModel.avatarRef(byId: userId))
    }
    
}
