//
//  MessageCell.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import UIKit
import Reusable
import TinyConstraints

protocol Messagable: UIView {
    func loadMessage(_ message: MessageProtocol, mergeNext: Bool, mergePrev: Bool)
    
    var mergeNext: Bool! { get set }
    var mergePrev: Bool! { get set }
}

class MessageCell: UITableViewCell, NibReusable, Messagable {
    
    // MARK: - Outlets
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var bubbleImage: UIImageView!
    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var stackTrailingAnchor: NSLayoutConstraint!
    @IBOutlet var stackLeadingAnchor: NSLayoutConstraint!
    @IBOutlet var stackBottomAnchor: NSLayoutConstraint!
    @IBOutlet var stackTopAnchor: NSLayoutConstraint!
    
    // MARK: - Vars
    var mergeNext: Bool!
    var mergePrev: Bool!
    var messageContent: Messagable!
    
    internal static let bubbleImageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "ru.coolone.epam-messenger.bubbleImageCache"
        return cache
    }()
    
    internal func getCachedImage() -> UIImage {
        let imageCacheKey = "bubble\(mergeNext ? "" : "_tails")"
        
        let cache = MessageCell.bubbleImageCache
        
        if let cachedImage = cache.object(forKey: imageCacheKey as NSString) {
            return message.isIncoming
                ? cachedImage
                : cachedImage.withHorizontallyFlippedOrientation()
        }
        
        let stretchedImage = UIImage(named: imageCacheKey)!
            .resizableImage(
                withCapInsets: UIEdgeInsets(
                    top: 17, left: 21, bottom: 17, right: 21
                ),
                resizingMode: .stretch
        ).withRenderingMode(.alwaysTemplate)
        
        cache.setObject(stretchedImage, forKey: imageCacheKey as NSString)
        
        return message.isIncoming
            ? stretchedImage
            : stretchedImage.withHorizontallyFlippedOrientation()
    }
    
    private var message: MessageProtocol! {
        didSet {
            setupBubbleImage()
            setupMessageContent()
            setupSideConstraints()
            setupAvatarImage()
        }
    }
    
    private func setupAvatarImage() {
        let isHidden = !message.isIncoming
        avatarImage.isHidden = isHidden
        
        if !isHidden {
            avatarImage.image = mergeNext ? nil : #imageLiteral(resourceName: "Nathan-Tannar")
            avatarImage.layer.cornerRadius = avatarImage.bounds.width / 2
        }
    }
    
    private func setupSideConstraints() {
        if message.isIncoming {
            stackTrailingAnchor.isActive = false
        } else {
            stackLeadingAnchor.isActive = false
        }
        
        if !mergeNext {
            stackBottomAnchor.constant = 5
        }
        
        if !mergePrev {
            stackTopAnchor.constant = 5
        }
    }
    
    private func setupMessageContent() {
        switch self.message {
        case let textMessage as TextMessageProtocol:
            messageContent = MessageTextContent()
            messageContent.loadMessage(
                textMessage,
                mergeNext: mergeNext,
                mergePrev: mergePrev
            )
        default:
            fatalError("Incorrect protocol")
        }
        bubbleImage.addSubview(messageContent)
    }
    
    private func setupBubbleImage() {
        bubbleImage.image = getCachedImage()
        bubbleImage.tintColor = message.isIncoming
            ? .plainBackground
            : .accent
    }
    
    func loadMessage(_ message: MessageProtocol, mergeNext: Bool, mergePrev: Bool) {
        self.mergeNext = mergeNext
        self.mergePrev = mergePrev
        self.message = message
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Disable selection color
        selectedBackgroundView = UIView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let messageContent = messageContent {
            messageContent.removeFromSuperview()
        }
        mergeNext = false
        
        stackTrailingAnchor.isActive = true
        stackLeadingAnchor.isActive = true
        stackTopAnchor.constant = 2
        stackBottomAnchor.constant = 2
    }
}
