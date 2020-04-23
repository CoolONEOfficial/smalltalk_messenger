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
    func pickPhotos(completion: @escaping ImageCompletion)
    func pickSinglePhoto(completion: @escaping ImageCompletion)
    func pickCamera(completion: @escaping ImageCompletion, device: UIImagePickerController.CameraDevice?)
    func showPickDialog(mode: ImagePickerDialog.Mode, completion: @escaping ImageCompletion)
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
    let cameraDevice: UIImagePickerController.CameraDevice
    
    // MARK: - Init
    
    init(viewController: UIViewController, cameraDevice: UIImagePickerController.CameraDevice) {
        self.viewController = viewController
        self.cameraDevice = cameraDevice
    }
    
    // MARK: - Methods
    
    func pickCamera(completion: @escaping ImageCompletion, device: UIImagePickerController.CameraDevice? = nil) {
        self.completion = completion
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = cameraDevice
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    func pickSinglePhoto(completion: @escaping ImageCompletion) {
        self.completion = completion
        imagePicker.sourceType = .photoLibrary
        viewController.present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhotos(completion: @escaping ImageCompletion) {
        self.completion = completion
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
    
    func showPickDialog(mode: ImagePickerDialog.Mode, completion: @escaping ImageCompletion) {
        self.completion = completion
        
        let dialog = ImagePickerDialog(delegate: self, mode: mode)
        viewController.present(dialog, animated: true)
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

extension ImagePickerService: ImagePickerDialogDelegate {
    
    func didCameraTap() {
        viewController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.pickCamera(completion: self.completion!)
        }
    }
    
    func didLastImageTap(_ image: UIImage) {
        completion!(image)
        viewController.dismiss(animated: true)
    }
    
    func didPhotosTap(mode: ImagePickerDialog.Mode) {
        switch mode {
        case .single:
            self.pickSinglePhoto(completion: self.completion!)
        case .multiple:
            self.pickPhotos(completion: self.completion!)
        }
    }
    
}
