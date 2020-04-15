//
//  ImagePickerService.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 27.03.2020.
//

import UIKit
import BSImagePicker
import Photos

typealias ImageCompletion = (UIImage) -> Void

protocol ImagePickerServiceProtocol: AutoMockable {
    func pickImages(completion: @escaping ImageCompletion)
    func pickSingleImage(completion: @escaping ImageCompletion)
    func pickCamera(completion: @escaping ImageCompletion)
}

class ImagePickerService: NSObject, ImagePickerServiceProtocol {
    
    // MARK: - Vars
    
    let viewController: UIViewController
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = ["public.image"]
        return picker
    }()
    
    private var completion: ImageCompletion?
    
    // MARK: - Init
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // MARK: - Methods
    
    func pickCamera(completion: @escaping ImageCompletion) {
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .front
        self.completion = completion
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    func pickSingleImage(completion: @escaping ImageCompletion) {
        imagePicker.sourceType = .photoLibrary
        self.completion = completion
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    func pickImages(completion: @escaping ImageCompletion) {
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

extension ImagePickerService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            if let image = image {
                self.completion?(image)
            } else {
                debugPrint("error while unwrapping selected image")
            }
        }
    }
    
}
