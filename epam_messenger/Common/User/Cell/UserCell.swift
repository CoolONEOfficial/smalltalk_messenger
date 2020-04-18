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
    
    @IBOutlet var avatar: AvatarView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    // MARK: - Vars
    
    var user: UserProtocol? {
        didSet {
            self.titleLabel.text = user?.fullName
            self.subtitleLabel.text = user?.onlineText
            self.subtitleLabel.textColor = user?.online ?? false
                ? .plainText
                : .secondaryLabel
        }
    }
    
    static let separatorLeftInset: CGFloat = 60
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAvatar()
    }
    
    private func setupAvatar() {
        avatar.layer.cornerRadius = avatar.frame.width / 2
    }

    // MARK: - Methods
    
    func loadUser(_ user: UserProtocol?, valueText: String? = nil) {
        self.user = user
        self.valueLabel.text = valueText
        self.valueLabel.isHidden = valueText != nil
        avatar.setup(withUser: user)
    }
    
    func loadUser(byId userId: String, completion: ((UserModel?) -> Void)? = nil) {
        FirestoreService().userData(userId) { [weak self] user in
            guard let self = self else { return }
            
            self.avatar.setup(withUser: user)
            self.user = user ?? .deleted()
            
            completion?(user)
        }
    }
}
