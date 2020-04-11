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
        sd_setImage(
            with: storageReference.small,
            maxImageSize: UInt64(1e+7), // 10mb
            placeholderImage: placeholderImage,
            options: [.progressiveLoad],
            completion: completion
        )
    }
}
