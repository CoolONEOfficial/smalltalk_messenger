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
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        separatorInset.left = 60
        
        setupAvatar()
    }
    
    private func setupAvatar() {
        avatar.layer.cornerRadius = avatar.frame.width / 2
    }

    // MARK: - Methods
    
    func loadUser(_ user: UserProtocol?, savedMessagesSupport: Bool = false, valueText: String? = nil) {
        self.user = user ?? UserModel.deleted(nil)
        self.valueLabel.text = valueText
        self.valueLabel.isHidden = valueText != nil
        avatar.setup(withUser: self.user!, savedMessagesSupport: savedMessagesSupport)
    }
    
    func loadUser(byId userId: String, savedMessagesSupport: Bool = false, completion: ((UserModel?) -> Void)? = nil) {
        FirestoreService().listenUserData(userId) { [weak self] user in
            guard let self = self else { return }
            
            self.user = user ?? .deleted(userId)
            self.avatar.setup(withUser: self.user!)
            
            completion?(user)
        }
    }
}
