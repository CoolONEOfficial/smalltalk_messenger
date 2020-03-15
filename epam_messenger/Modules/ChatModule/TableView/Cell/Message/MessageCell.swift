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
    func loadMessage(_ message: MessageProtocol)
}

class MessageCell: UITableViewCell, NibReusable, Messagable {

    // MARK: - Outlets
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var bubbleImage: UIImageView!
    @IBOutlet var stackView: UIStackView!
    
    // MARK: - Vars
    
    var mergeNext: Bool!
    var messageContent: Messagable!
    
    private var message: MessageProtocol! {
        didSet {
            bubbleImage.image = UIImage(named: "bubble_\(message.isIncoming ? "in" : "out")coming\(mergeNext ? "" : "_tails")")!
                .resizableImage(
                    withCapInsets: UIEdgeInsets(
                        top: 17, left: 21, bottom: 17, right: 21
                    ),
                    resizingMode: .stretch
            ).withRenderingMode(.alwaysTemplate)
            tintColor = message.isIncoming
                ? .plainBackground
                : .accent
            
            switch self.message {
            case let textMessage as TextMessageProtocol:
                messageContent = MessageTextContent()
                messageContent.loadMessage(textMessage)
            default:
                fatalError("Incorrect protocol")
            }
            
            // content.edges(to: bubbleImage)
            bubbleImage.addSubview(messageContent)
            self.contentView.width(250, relation: .equalOrLess, priority: .required)
            if message.isIncoming {
                stackView.leading(to: self, offset: 8)
            } else {
                stackView.trailing(to: self, offset: -8)
            }
            
            avatarImage.image = #imageLiteral(resourceName: "Nathan-Tannar")
            avatarImage.layer.cornerRadius = avatarImage.bounds.width / 2
            avatarImage.isHidden = !message.isIncoming
        }
    }
    
    func loadMessage(_ message: MessageProtocol) {
        self.message = message
    }
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Disable selection color
        selectedBackgroundView = UIView()
    }
    
    override func prepareForReuse() {
        if let messageContent = messageContent {
            messageContent.removeFromSuperview()
        }
    }

}
