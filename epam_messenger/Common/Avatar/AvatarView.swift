//
//  AvatarView.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 14.04.2020.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import SDWebImage

class AvatarView: UIImageView {
    
    // MARK: - Vars
    
    let loading = UIActivityIndicatorView()
    var placeholderLabel = UILabel()
    
    override var image: UIImage? {
        didSet {
            placeholderLabel.isHidden = image != nil
        }
    }
    
    // MARK: - Init
    
    internal func baseSetup(roundCorners: Bool = true, cornerRadius: CGFloat? = nil) {
        contentMode = .scaleAspectFill
        layer.cornerRadius = roundCorners
            ? cornerRadius != nil
                ? cornerRadius!
                : bounds.width / 2
            : 0
        layer.masksToBounds = true
        placeholderLabel.removeFromSuperview()
        set(image: nil, focusOnFaces: true)
        backgroundColor = nil
    }
    
    private func setupPlaceholder(_ text: String?, _ color: UIColor?) {
        placeholderLabel.font = UIFont.systemFont(ofSize: bounds.height / 5 * 2, weight: .semibold)
        placeholderLabel.textColor = UIColor.lightText.withAlphaComponent(1)
        placeholderLabel.numberOfLines = 1
        placeholderLabel.textAlignment = .center
        placeholderLabel.lineBreakMode = .byClipping
        placeholderLabel.text = text?.uppercased()
        backgroundColor = color ?? .accent
        
        addSubview(placeholderLabel)
        placeholderLabel.edgesToSuperview()
    }
    
    override func awakeFromNib() {
        addSubview(loading)
        loading.centerInSuperview()
        loading.startAnimating()
    }
    
    func setup(withUser user: UserProtocol, savedMessagesSupport: Bool = false) {
        if let userId = user.documentId, !user.deleted {
            if savedMessagesSupport && userId == Auth.auth().currentUser!.uid {
               setupBookmark()
            } else if user.isAvatarExists != nil {
               setup(
                   withRef: user.avatarRef,
                   text: user.placeholderName,
                   color: user.color
               )
            } else {
                setup(
                    withPlaceholder: user.placeholderName,
                    color: user.color
                )
            }
        } else {
            setup(withImage: #imageLiteral(resourceName: "ic_unknown_user"))
        }
    }
    
    func setup(
        withChat chat: (title: String, adminId: String, hexColor: String?, avatarPath: String?),
        avatarRef: StorageReference?,
        roundCorners: Bool = true
    ) {
        let placeholderText = String(chat.title.first!)
        let placeholderColor = UIColor(hexString: chat.hexColor) ?? .accent
        
        if chat.avatarPath != nil {
            setup(
                withRef: avatarRef!,
                text: placeholderText,
                color: placeholderColor,
                roundCorners: roundCorners
            )
        } else {
            setup(
                withPlaceholder: placeholderText,
                color: placeholderColor,
                roundCorners: roundCorners
            )
        }
    }
    
    func setup(
        withRef ref: StorageReference,
        text: String,
        color: UIColor? = nil,
        roundCorners: Bool = true,
        cornerRadius: CGFloat? = nil
    ) {
        baseSetup(roundCorners: roundCorners, cornerRadius: cornerRadius)
        
        if frame.width > 200 {
            sd_setImage(
                with: ref,
                placeholderImage: SDImageCache.shared.imageFromDiskCache(forKey: ref.small.storageLocation),
                completion: didLoadImage(text, color)
            )
        } else {
            sd_setSmallImage(
                with: ref,
                completion: didLoadImage(text, color)
            )
        }
    }
    
    func didLoadImage(
        _ text: String,
        _ color: UIColor?
    ) -> (
        _ image: UIImage?,
        _ err: Error?,
        _ cacheType: SDImageCacheType,
        _ storageRef: StorageReference
    ) -> Void { { [weak self] _, err, _, _ in
        guard let self = self else { return }
        self.loading.removeFromSuperview()
        
        if err != nil {
            self.setupPlaceholder(text, color)
        }
    } }
    
    func setup(
        withPlaceholder text: String? = nil,
        color: UIColor?,
        roundCorners: Bool = true,
        cornerRadius: CGFloat? = nil
    ) {
        baseSetup(roundCorners: roundCorners, cornerRadius: cornerRadius)
        
        loading.removeFromSuperview()
        setupPlaceholder(text, color)
    }
    
    func setup(withImage image: UIImage? = nil) {
        baseSetup()
        
        loading.removeFromSuperview()
        self.image = image
    }
    
    func setupBookmark() {
        baseSetup()
        contentMode = .center
        
        backgroundColor = .accent
        loading.removeFromSuperview()
        image = UIImage(systemName: "bookmark.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        tintColor = .white
    }
    
    func reset() {
        baseSetup()
    }
}
