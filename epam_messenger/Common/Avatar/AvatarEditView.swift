//
//  AvatarEditView.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 20.04.2020.
//

import UIKit
import FirebaseStorage
import ChromaColorPicker

protocol AvatarEditViewDelegate: AnyObject {
    func didChangeImage(_ image: UIImage?)
    func didChangeColor(_ color: UIColor)
}

class AvatarEditView: AvatarView {
    
    // MARK: - Vars
    
    let colorWheelOrDelete = UIImageView()
    let photoPlaceholder = UIImageView()
    var imagePickerService: ImagePickerServiceProtocol?
    
    weak var delegate: AvatarEditViewDelegate?
    
    // MARK: - Init
    
    override var image: UIImage? {
        didSet {
            refreshColorWheelOrDelete()
            refreshPhotoPlaceholder()
            self.delegate?.didChangeImage(image)
        }
    }
    
    private func setupColorWheelOrDelete() {
        colorWheelOrDelete.layer.cornerRadius = 12
        colorWheelOrDelete.backgroundColor = .accent
        colorWheelOrDelete.tintColor = .accentText
        colorWheelOrDelete.hero.id = "color_wheel"
        colorWheelOrDelete.layer.masksToBounds = true
        colorWheelOrDelete.isUserInteractionEnabled = true
        colorWheelOrDelete.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(didColorWheelOrDeleteTap)
        ))
    }
    
    private func setupCameraImage() {
        photoPlaceholder.contentMode = .center
        photoPlaceholder.tintColor = .white
        photoPlaceholder.isUserInteractionEnabled = true
        photoPlaceholder.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(didTap)
        ))
    }
    
    override func setup(withPlaceholder text: String? = nil, color: UIColor = .accent) {
        super.setup(withPlaceholder: text, color: color)
        refreshPhotoPlaceholderAlpha(text)
    }
    
    override func setup(withRef ref: StorageReference, text: String, color: UIColor, roundCorners: Bool = true, cornerRadius: CGFloat? = nil) {
        super.setup(withRef: ref, text: text, color: color)
        refreshPhotoPlaceholderAlpha(text)
    }
    
    private func refreshPhotoPlaceholderAlpha(_ text: String?) {
        photoPlaceholder.alpha = (text?.isEmpty ?? true) ? 1 : 0.2
    }
    
    override func baseSetup(roundCorners: Bool = true, cornerRadius: CGFloat? = nil) {
        super.baseSetup(roundCorners: roundCorners, cornerRadius: cornerRadius)
        setupColorWheelOrDelete()
        setupCameraImage()
        
        guard let superview = superview else { return }
        
        if photoPlaceholder.superview == nil {
            superview.addSubview(photoPlaceholder)
            photoPlaceholder.edges(to: self, insets: .uniform(10))
        }
        
        if colorWheelOrDelete.superview == nil {
            superview.addSubview(colorWheelOrDelete)
            colorWheelOrDelete.size(.init(width: 24, height: 24))
            colorWheelOrDelete.centerX(to: self)
            colorWheelOrDelete.bottom(to: self, offset: 12)
        }
        refreshColorWheelOrDelete()
        refreshPhotoPlaceholder()
    }
    
    private func refreshColorWheelOrDelete() {
        colorWheelOrDelete.image = image == nil
            ? #imageLiteral(resourceName: "ic_color_wheel")
            : UIImage(
                systemName: "trash.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 12)
        )
        colorWheelOrDelete.contentMode = image == nil
            ? .scaleAspectFit
            : .center
    }
    
    private func refreshPhotoPlaceholder() {
        photoPlaceholder.image = UIImage(
            systemName: "photo.fill.on.rectangle.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: frame.height / 3)
        )
        photoPlaceholder.isHidden = image != nil
    }
    
    // MARK: - Actions
    
    @objc private func didTap() {
        imagePickerService?.showPickDialog(mode: .single) { [weak self] image in
            guard let self = self else { return }
            self.image = image
        }
    }
    
    @objc private func didColorWheelOrDeleteTap() {
        if image == nil {
            let vc = ColorPickerViewController(
                initialColor: backgroundColor ?? UIColor.accent
            )
            vc.modalPresentationStyle = .overFullScreen
            vc.isHeroEnabled = true
            vc.delegate = self
            let topMostController = Router.topMostController
            topMostController.isHeroEnabled = true
            topMostController.present(vc, animated: true, completion: nil)
        } else {
            image = nil
            if backgroundColor == nil {
                backgroundColor = .accent
            }
        }
    }
    
}

extension AvatarEditView: ChromaColorPickerDelegate {
    
    func colorPickerHandleDidChange(_ colorPicker: ChromaColorPicker, handle: ChromaColorHandle, to color: UIColor) {
        backgroundColor = color
        delegate?.didChangeColor(color)
    }
    
}
