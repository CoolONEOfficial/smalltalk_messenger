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
        self.valueLabel.isHidden = valueText != nil
        avatarImage.sd_setSmallImage(with: user.avatarRef, placeholderImage: #imageLiteral(resourceName: "logo"))
    }
    
    func loadUser(byId userId: String, completion: ((UserModel?) -> Void)? = nil) {
        FirestoreService().userData(userId) { user in
            self.user = user
            completion?(user)
        }
        avatarImage.sd_setSmallImage(with: UserModel.avatarRef(byId: userId), placeholderImage: #imageLiteral(resourceName: "logo"))
    }
    
}
