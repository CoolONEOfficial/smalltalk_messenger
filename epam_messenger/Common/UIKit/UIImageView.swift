//
//  UIImageView.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 02.04.2020.
//

import UIKit
import FirebaseStorage
import SDWebImage

extension UIImageView {
    func sd_setSmallImage(
        with storageReference: StorageReference,
        placeholderImage: UIImage? = nil,
        completion: ((UIImage?, Error?, SDImageCacheType, StorageReference) -> Void)? = nil
    ) {
        var path = storageReference.fullPath
        path.insert(contentsOf: "_200x200", at: path.index(path.endIndex, offsetBy: -4))
        sd_setImage(
            with: Storage.storage().reference(withPath: path),
            placeholderImage: placeholderImage,
            completion: completion
        )
    }
}
