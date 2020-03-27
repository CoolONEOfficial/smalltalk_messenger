//
//  MessageImageContent.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 22.03.2020.
//

import UIKit
import FirebaseStorage
import FirebaseUI
import TinyConstraints
import NYTPhotoViewer

class MessageImageContent: UIView, MessageCellContentProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var infoStack: UIStackView!
    
    // MARK: - Vars
    
    var backgroundImageView: UIImageView!
    
    var shouldSetupConstraints = true
    var superInsets: TinyEdgeInsets!
    
    var cell: MessageCellProtocol!
    var mergeContentNext: Bool!
    var mergeContentPrev: Bool!
    var kindIndex: Int!
    var imageMessage: MessageImageProtocol! {
        didSet {
            setupImage()
            setupStack()
            
            layer.cornerRadius = MessageCell.cornerRadius
            layer.masksToBounds = true
            if mergeContentPrev || mergeContentNext {
                layer.maskedCorners = !mergeContentNext
                    ? [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] : !mergeContentPrev
                    ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] : []
            }
        }
    }
    var message: MessageProtocol! {
        return imageMessage
    }
    
    var topMargin: CGFloat {
        return 0
    }
    
    var bottomMargin: CGFloat {
        return 0
    }
    
    private func setupImage() {
        let kindImage = imageMessage.kindImage(at: kindIndex)!
        let imageRef = Storage.storage().reference().child(kindImage.path)
        let placeholderImage = imageWithSize(size: kindImage.size)
        imageView.sd_setImage(
            with: imageRef,
            placeholderImage: placeholderImage
        ) { image, err, _, _ in
            guard err == nil else {
                return
            }
            
            self.backgroundImageView?.removeFromSuperview()
            
            self.backgroundImageView = UIImageView(frame: self.imageView.bounds)
            self.backgroundImageView.contentMode = .scaleAspectFill
            self.backgroundImageView.image = image?.darkened()
            self.contentView.insertSubview(self.backgroundImageView, at: 0)
        }
    }
    
    private func setupStack() {
        infoStack.isHidden = mergeContentNext
        infoStack.addBackground(color: .chatRectLabelBackground, cornerRadius: infoStack.bounds.height / 2)
        timeLabel.textColor = .chatRectLabelText
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MessageImageContent", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Methods
    
    func loadMessage(
        _ message: MessageProtocol,
        index: Int,
        cell: MessageCellProtocol,
        mergeContentNext: Bool,
        mergeContentPrev: Bool
    ) {
        self.kindIndex = index
        self.cell = cell
        self.mergeContentNext = mergeContentNext
        self.mergeContentPrev = mergeContentPrev
        self.imageMessage = message as? MessageImageProtocol
    }
    
    override func updateConstraints() {
        if shouldSetupConstraints {
            
            horizontalToSuperview()
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
    // MARK: - Helpers
    
    func imageWithSize(
        size: CGSize,
        filledWithColor color: UIColor = .clear,
        scale: CGFloat = 0.0,
        opaque: Bool = false
    ) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        color.set()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}

// MARK: Image darken helper

fileprivate extension UIImage {
    func darkened() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        guard let ctx = UIGraphicsGetCurrentContext(), let cgImage = cgImage else {
            return nil
        }
        
        // flip the image, or result appears flipped
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.translateBy(x: 0, y: -size.height)
        
        let rect = CGRect(origin: .zero, size: size)
        ctx.draw(cgImage, in: rect)
        UIColor(white: 0, alpha: 0.5).setFill()
        ctx.fill(rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
