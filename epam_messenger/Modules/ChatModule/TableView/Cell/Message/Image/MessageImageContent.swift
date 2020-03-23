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

class MessageImageContent: UIView, MessageCellContentProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var infoStack: UIStackView!
    
    // MARK: - Vars
    
    var shouldSetupConstraints = true
    var superInsets: TinyEdgeInsets!
    
    var cell: MessageCellProtocol!
    var mergeContentNext: Bool!
    var mergeContentPrev: Bool!
    var imageMessage: MessageImageProtocol! {
        didSet {
            setupImage()
            setupStack()
        }
    }
    
    var topMargin: CGFloat {
        return 0
    }
    
    var bottomMargin: CGFloat {
        return 0
    }
    
    private func setupImage() {
        let imageRef = Storage.storage().reference().child(imageMessage.image!.path)
        imageView.layer.cornerRadius = MessageCell.cornerRadius
        imageView.layer.masksToBounds = true
        if mergeContentPrev || mergeContentNext {
            imageView.layer.maskedCorners = !mergeContentNext
                ? [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] : !mergeContentPrev
                ? [.layerMinXMinYCorner, .layerMaxXMinYCorner] : []
        }
        let placeholderImage = imageWithSize(size: imageMessage.image!.size)
        imageView.sd_setImage(
            with: imageRef,
            placeholderImage: placeholderImage
        ) { image, err, _, _ in
            
            self.imageView.backgroundColor = UIColor(patternImage: image!).withAlphaComponent(0.5)
            
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
    
    func loadMessage(_ message: MessageProtocol, cell: MessageCellProtocol, mergeContentNext: Bool, mergeContentPrev: Bool) {
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
