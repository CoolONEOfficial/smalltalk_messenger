//
//  ChatInputBarAttachmentManager.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 22.03.2020.
//

import Foundation
import InputBarAccessoryView
import BSImagePicker
import Photos

extension ChatViewController: AttachmentManagerDelegate {
    
    // MARK: - AttachmentManagerDelegate
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        refreshSendButton(manager)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        refreshSendButton(manager)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        refreshSendButton(manager)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        let imagePicker = ImagePickerController()
        let theme = imagePicker.settings.theme
        theme.backgroundColor = .systemBackground
        theme.selectionFillColor = .accent
        imagePicker.navigationBar.barTintColor = .systemBackground
        imagePicker.view.tintColor = .accent
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        presentImagePicker(imagePicker, select: nil, deselect: nil, cancel: { _ in
            self.updateTableViewInset()
        }, finish: { (assets) in
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
                        
                        guard !even && !self.attachmentManager.attachments.contains(where: { (att: AttachmentManager.Attachment) in
                            switch att {
                            case .image(let attachmentImage):
                                debugPrint("compare \(image.size) \(attachmentImage.size)")
                                return attachmentImage == image
                            default:
                                return false
                            }
                        }) else {
                            return
                        }
                        self.attachmentManager.handleInput(of: image)
                    } else {
                        debugPrint("Error while unwrapping selected image")
                    }
                }
            }
        })
        
    }
    
    // MARK: - Helpers
    
    func refreshSendButton(_ manager: AttachmentManager) {
        inputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func setAttachmentManager(active: Bool) {
        
        let topStackView = inputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
}

//extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.pickerController(picker, didSelect: nil)
//        updateTableViewInset()
//    }
//
//    public func imagePickerController(
//        _ picker: UIImagePickerController,
//        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
//    ) {
//        guard let image = info[.editedImage] as? UIImage else {
//            return self.pickerController(picker, didSelect: nil)
//        }
//        self.pickerController(picker, didSelect: image)
//    }
//
//    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
//        controller.dismiss(animated: true) {
//            if let pickedImage = image {
//                self.attachmentManager.handleInput(of: pickedImage)
//            } else {
//                debugPrint("Error while unwrapping selected image")
//            }
//        }
//    }
//}
