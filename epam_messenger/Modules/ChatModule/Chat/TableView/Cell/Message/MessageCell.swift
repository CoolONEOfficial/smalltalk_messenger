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

let messageInset: CGFloat = 10
let messageAdditionalInset: CGFloat = 4
let messageTailsInset: CGFloat = 4

protocol MessageCellProtocol: UIView {
    func loadMessage(_ message: MessageProtocol, mergeNext: Bool, mergePrev: Bool)
    func makeBubbleMaskLayer(top: Bool, bottom: Bool, height: CGFloat?) -> CALayer
    
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

protocol MessageCellDelegate: AnyObject {
    func didTapContent(_ content: MessageCellContentProtocol)
    func didError(_ text: String)
    func cellUserData(_ userId: String, completion: @escaping (UserModel?) -> Void)
    
    var chat: ChatProtocol { get }
}

class MessageCell: UITableViewCell, NibReusable, MessageCellProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var bubbleView: UIView!
    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var stackTrailingAnchor: NSLayoutConstraint!
    @IBOutlet var stackLeadingAnchor: NSLayoutConstraint!
    @IBOutlet var stackTopAnchor: NSLayoutConstraint!
    
    // MARK: - Vars
    
    var mergeNext: Bool!
    var mergePrev: Bool!
    
    weak var delegate: MessageCellDelegate? {
        didSet {
            loadUser()
            if case .personalCorr = delegate!.chat.type {
                avatarImage.isHidden = true
            }
            for content in contentStack.subviews as! [MessageCellContentProtocol] {
                content.didDelegateSet(delegate)
            }
        }
    }
    
    var messageLayer: CAShapeLayer!
    
    var contentSizeObserver: NSKeyValueObservation?
    var _contentStack: UIStackView?
    var contentStack: UIStackView {
        if _contentStack == nil {
            let newStack = UIStackView()
            newStack.translatesAutoresizingMaskIntoConstraints = false
            newStack.axis = .vertical
            newStack.spacing = 4
            newStack.distribution = .fillProportionally
            newStack.isUserInteractionEnabled = true
            
            bubbleView.addSubview(newStack)
            newStack.horizontalToSuperview(
                insets: message.isIncoming
                    ? .left(messageTailsInset) + .right(0)
                    : .left(0) + .right(messageTailsInset)
            )
            _contentStack = newStack
        }
        
        return _contentStack!
    }
    
    internal var message: MessageProtocol! {
        didSet {
            setupMessageContent()
            setupSideConstraints()
            setupAvatarImage()
            setupBubbleImage()
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
        
        stackTopAnchor.constant = mergePrev
            ? 4
            : 10
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
    
    func makeBubbleMask(withTale: Bool, top: Bool = true, bottom: Bool = true, height: CGFloat? = nil) -> UIBezierPath {
        let width = bubbleView.bounds.width
        let height = height ?? bubbleView.bounds.height
        
        let bezierPath: UIBezierPath
        
        if withTale {
            bezierPath = .init()
            
            bezierPath.move(to: .init(
                x: width - (bottom ? 22 : 4),
                y: height
            ))
            bezierPath.addLine(to: CGPoint(x: bottom ? 17 : 0, y: height))
            if bottom { // left bottom corner
                bezierPath.addCurve(
                    to: CGPoint(x: 0, y: height - 17),
                    controlPoint1: .init(x: 7.61, y: height),
                    controlPoint2: .init(x: 0, y: height - 7.61)
                )
            }
            bezierPath.addLine(to: .init(
                x: 0,
                y: top ? 17 : 0
            ))
            if top { // left top corner
                bezierPath.addCurve(
                    to: CGPoint(x: 17, y: 0),
                    controlPoint1: .init(x: 0, y: 7.61),
                    controlPoint2: .init(x: 7.61, y: 0)
                )
            }
            bezierPath.addLine(to: CGPoint(
                x: width - (top ? 21 : 4),
                y: 0
            ))
            if top { // right top corner
                bezierPath.addCurve(
                    to: CGPoint(x: width - 4, y: 17),
                    controlPoint1: .init(x: width - 11.61, y: 0),
                    controlPoint2: .init(x: width - 4, y: 7.61)
                )
            }
            bezierPath.addLine(to: .init(
                x: width - 4,
                y: height - (bottom ? 11 : 0)
            ))
            if bottom { // right bottom corner
                bezierPath.addCurve(
                    to: CGPoint(x: width, y: height),
                    controlPoint1: .init(x: width - 4, y: height - 1),
                    controlPoint2: .init(x: width, y: height)
                )
                bezierPath.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
                bezierPath.addCurve(
                    to: CGPoint(x: width - 11.04, y: height - 4.04),
                    controlPoint1: .init(x: width - 4.07, y: height + 0.43),
                    controlPoint2: .init(x: width - 8.16, y: height - 1.06)
                )
                bezierPath.addCurve(
                    to: CGPoint(x: width - 22, y: height),
                    controlPoint1: .init(x: width - 16, y: height),
                    controlPoint2: .init(x: width - 19, y: height)
                )
            }
            bezierPath.close()
        } else {
            let rect = CGRect(
                origin: .zero,
                size: .init(
                    width: bubbleView.bounds.width - messageTailsInset,
                    height: bubbleView.bounds.height
                )
            )
            let radius: CGFloat = 19
            bezierPath = top && bottom
                ? .init(
                    roundedRect: rect,
                    cornerRadius: radius
                )
                : .init(
                    roundedRect: .init(
                        origin: .zero,
                        size: .init(
                            width: bubbleView.bounds.width - messageTailsInset,
                            height: bubbleView.bounds.height
                        )
                    ),
                    byRoundingCorners: top
                        ? [.topLeft, .topRight]
                        : bottom
                        ? [.bottomLeft, .bottomRight]
                        : [],
                    cornerRadii: .init(width: radius, height: radius)
                )
        }

        if message.isIncoming {
            bezierPath.apply(.init(scaleX: -1.0, y: 1.0))
            bezierPath.apply(.init(translationX: width, y: 0))
        }
        
        return bezierPath
    }
    
    func makeBubbleMaskPath(top: Bool = true, bottom: Bool = true, height: CGFloat? = nil) -> UIBezierPath {
        makeBubbleMask(withTale: !mergeNext, top: top, bottom: bottom, height: height)
    }
    
    func makeBubbleMaskLayer(top: Bool = true, bottom: Bool = true, height: CGFloat? = nil) -> CALayer {
        let maskLayer = CAShapeLayer()
        maskLayer.path =  makeBubbleMaskPath(top: top, bottom: bottom, height: height).cgPath
        return maskLayer
    }
    
    private func refreshBubbleImage(width: CGFloat, height: CGFloat) {
        messageLayer?.removeFromSuperlayer()
        messageLayer = .init()
        
        bubbleView.layer.mask = makeBubbleMaskLayer()
        bubbleView.backgroundColor = message.isIncoming
            ? UIColor.plainBackground
            : UIColor.accent
        
        messageLayer.frame = bubbleView.bounds
        
        bubbleView.layer.insertSublayer(messageLayer, at: 0)
    }
    
    internal func setupBubbleImage() {
        contentSizeObserver = contentStack.observe(\.bounds, changeHandler: { (_, _) in
            self.refreshBubbleImage(
                width: self.bubbleView.frame.width,
                height: self.bubbleView.frame.height
            )
        })
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
        
        messageLayer?.removeFromSuperlayer()
        messageLayer = nil
        contentSizeObserver = nil
        
        do {
            contentStack.removeFromSuperview()
        } catch {
            debugPrint("error while remove contentstack from \(bubbleView)")
        }
        _contentStack = nil
        
        mergeNext = false
        mergePrev = false
        
        stackTrailingAnchor.isActive = true
        stackLeadingAnchor.isActive = true
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
