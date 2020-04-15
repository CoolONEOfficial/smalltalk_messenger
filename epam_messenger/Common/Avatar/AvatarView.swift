//
//  AvatarView.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 14.04.2020.
//

import UIKit
import FirebaseStorage

class AvatarView: UIImageView {
    
    // MARK: - Vars
    
    let loading = UIActivityIndicatorView()
    var placeholderLabel = UILabel()
    var baseSetupCompleted = false
    
    // MARK: - Init
    
    private func baseSetup(roundCorners: Bool = true) {
        if !baseSetupCompleted {
            layer.cornerRadius = roundCorners ? bounds.width / 2 : 0
            layer.masksToBounds = true
            contentMode = .scaleAspectFill
            baseSetupCompleted = true
        }
    }
    
    private func setupPlaceholder(_ text: String?, _ color: UIColor) {
        placeholderLabel.font = UIFont.systemFont(ofSize: bounds.height / 5 * 2, weight: .semibold)
        placeholderLabel.textColor = UIColor.lightText.withAlphaComponent(1)
        placeholderLabel.numberOfLines = 1
        placeholderLabel.textAlignment = .center
        placeholderLabel.lineBreakMode = .byClipping
        placeholderLabel.text = text?.uppercased()
        backgroundColor = color
        
        addSubview(placeholderLabel)
        placeholderLabel.edgesToSuperview()
    }
    
    override func awakeFromNib() {
        addSubview(loading)
        loading.centerInSuperview()
        loading.startAnimating()
    }
    
    func setup(withUser user: UserProtocol?) {
        if let user = user {
            setup(
                withRef: user.avatarRef,
                text: user.placeholderName,
                color: user.color ?? .accent
            )
        } else {
            setup(withImage: #imageLiteral(resourceName: "ic_unknown_user"))
        }
    }
    
    func setup(withRef ref: StorageReference, text: String, color: UIColor, roundCorners: Bool = true) {
        baseSetup(roundCorners: roundCorners)
        
        sd_setSmallImage(with: ref) { [weak self] _, err, _, _ in
            guard let self = self else { return }
            self.loading.removeFromSuperview()
            
            if err != nil {
                self.setupPlaceholder(text, color)
            }
        }
    }
    
    func setup(withPlaceholder text: String? = nil, color: UIColor = .accent) {
        baseSetup()
        
        loading.removeFromSuperview()
        image = nil
        setupPlaceholder(text, color)
    }
    
    func setup(withImage image: UIImage? = nil) {
        baseSetup()
        
        loading.removeFromSuperview()
        placeholderLabel.removeFromSuperview()
        set(image: image, focusOnFaces: true)
    }
    
}
