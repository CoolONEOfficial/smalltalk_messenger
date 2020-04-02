//
//  MessageCell.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import UIKit
import Reusable
import FirebaseStorage
import TinyConstraints

protocol MessageCellProtocol: UIView {
    func loadMessage(_ message: MessageProtocol, mergeNext: Bool, mergePrev: Bool)
    
    var mergeNext: Bool! { get set }
    var mergePrev: Bool! { get set }
    
    var delegate: MessageCellDelegate? { get }
}

protocol MessageCellContentProtocol: UIView {
    func loadMessage(
        _ message: MessageProtocol,
        index: Int,
        cell: MessageCellProtocol,
        mergeContentNext: Bool,
        mergeContentPrev: Bool
    )
    
    var message: MessageProtocol! { get }
    var kindIndex: Int! { get set }
    
    var cell: MessageCellProtocol! { get set }
    var mergeContentNext: Bool! { get set }
    var mergeContentPrev: Bool! { get set }
    
    var topMargin: CGFloat { get }
    var bottomMargin: CGFloat { get }
    
    func didTap(_ recognizer: UITapGestureRecognizer)
    func didLoadUser(_ user: UserProtocol)
    func didDelegateSet(_ delegate: MessageCellDelegate?)
}

extension MessageCellContentProtocol {
    func didTap(_ recognizer: UITapGestureRecognizer) {}
    func didLoadUser(_ user: UserProtocol) {}
    func didDelegateSet(_ delegate: MessageCellDelegate?) {}
}

protocol MessageCellDelegate {
    func didTapContent(_ content: MessageCellContentProtocol)
    func didError(_ text: String)
    func cellUserData(_ userId: String, completion: @escaping (UserModel?) -> Void)
    
    var chatType: ChatType { get }
}

class MessageCell: UITableViewCell, NibReusable, MessageCellProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var bubbleImage: UIImageView!
    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var stackTrailingAnchor: NSLayoutConstraint!
    @IBOutlet var stackLeadingAnchor: NSLayoutConstraint!
    @IBOutlet var stackBottomAnchor: NSLayoutConstraint!
    @IBOutlet var stackTopAnchor: NSLayoutConstraint!
    
    static let cornerRadius: CGFloat = 16.5
    
    // MARK: - Vars
    
    var mergeNext: Bool!
    var mergePrev: Bool!
    
    var delegate: MessageCellDelegate? {
        didSet {
            loadUser()
            if case .personalCorr = delegate!.chatType {
                avatarImage.isHidden = true
            }
            for content in contentStack.subviews as! [MessageCellContentProtocol] {
                content.didDelegateSet(delegate)
            }
        }
    }
    
    var _contentStack: UIStackView?
    var contentStack: UIStackView {
        if _contentStack == nil {
            let newStack = UIStackView()
            newStack.translatesAutoresizingMaskIntoConstraints = false
            newStack.axis = .vertical
            newStack.spacing = 4
            newStack.distribution = .fillProportionally
            newStack.isUserInteractionEnabled = true
            
            bubbleImage.addSubview(newStack)
            newStack.horizontalToSuperview(
                insets: message.isIncoming
                    ? .left(6) + .right(0)
                    : .left(0) + .right(6)
            )
            _contentStack = newStack
        }
        
        return _contentStack!
    }
    
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
    
    internal var message: MessageProtocol! {
        didSet {
            setupBubbleImage()
            setupMessageContent()
            setupSideConstraints()
            setupAvatarImage()
        }
    }
    
    private func loadUser() {
        if message.isIncoming {
            delegate?.cellUserData(message.userId) { userModel in
                if let userModel = userModel {
                    for content in self.contentStack.subviews as? [MessageCellContentProtocol] ?? [] {
                        content.didLoadUser(userModel)
                    }
                }
            }
        }
    }
    
    private func setupAvatarImage() {
        let isHidden = !message.isIncoming
        avatarImage.isHidden = isHidden
        
        if !isHidden {
            if !mergeNext {
                avatarImage.image = #imageLiteral(resourceName: "Nathan-Tannar")
                avatarImage.sd_setSmallImage(with: Storage.storage().reference(
                    withPath: "users/\(message.userId)/avatar.jpg"
                ))
            } else {
                avatarImage.image = nil
            }
            
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
        for (index, kind) in message.kind.enumerated() {
            var contentView: MessageCellContentProtocol!
            switch kind {
            case .text:
                contentView = MessageTextContent()
            case .image:
                contentView = MessageImageContent()
            case .audio:
                contentView = MessageAudioContent()
            case .forward:
                contentView = MessageForwardContent()
            }
            contentView.loadMessage(
                self.message,
                index: index,
                cell: self,
                mergeContentNext: index != message.kind.count - 1,
                mergeContentPrev: index != 0
            )
            contentStack.addArrangedSubview(contentView)
            
            if index == 0 {
                contentStack.topToSuperview(offset: contentView.topMargin)
            }
            if index == message.kind.count - 1 {
                contentStack.bottomToSuperview(offset: -contentView.bottomMargin)
            }
        }
    }
    
    private func setupBubbleImage() {
        bubbleImage.image = getCachedImage()
        bubbleImage.tintColor = message.backgroundColor
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
        
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didCellTap(_:))))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentStack.removeFromSuperview()
        _contentStack = nil
        
        mergeNext = false
        mergePrev = false
        
        stackTrailingAnchor.isActive = true
        stackLeadingAnchor.isActive = true
        stackTopAnchor.constant = 2
        stackBottomAnchor.constant = 2
    }
    
    // MARK: - Actions
    
    @objc func didCellTap(_ recognizer: UITapGestureRecognizer) {
        for content in contentStack.subviews {
            let tapLocation = recognizer.location(in: contentStack)
            if content.frame.contains(tapLocation),
                let content = content as? MessageCellContentProtocol {
                content.didTap(recognizer)
                delegate?.didTapContent(content)
            }
        }
    }
}
