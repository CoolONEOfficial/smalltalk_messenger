//
//  ImagePickerService.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 27.03.2020.
//

import UIKit
import BSImagePicker
import Photos

protocol ImagePickerServiceProtocol: AutoMockable {
    func pickImages(
        viewController: UIViewController,
        completion: @escaping (UIImage) -> Void
    )
}

class ImagePickerService: ImagePickerServiceProtocol {
    
    func pickImages(viewController: UIViewController, completion: @escaping (UIImage) -> Void) {
        let imagePicker = ImagePickerController()
        let theme = imagePicker.settings.theme
        
        theme.backgroundColor = .systemBackground
        theme.selectionFillColor = .accent
        imagePicker.navigationBar.barTintColor = .systemBackground
        imagePicker.view.tintColor = .accent
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        viewController.presentImagePicker(imagePicker, select: nil, deselect: nil, cancel: nil, finish: { (assets) in
            for asset in assets {
                let options = PHImageRequestOptions()
                options.deliveryMode = .highQualityFormat
                options.resizeMode = .none
                options.version = .original
                var even = false
                PHImageManager.default().requestImage(
                    for: asset,
                    targetSize: CGSize(),
                    contentMode: .default,
                    options: nil
                ) { (image: UIImage?, _) in
                    if let image = image {
                        even = !even
                        guard !even else {
                            return
                        }
                        
                        completion(image)
                    } else {
                        debugPrint("Error while unwrapping selected image")
                    }
                }
            }
        })
    }
}
