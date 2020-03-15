//
//  MessageTextContent.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import UIKit
import TinyConstraints

extension UILabel {
    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}

class MessageTextContent: UIView, Messagable {
    
    // MARK: - Outlets
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    // MARK: - Vars
    
    var superInsets: TinyEdgeInsets!
    var shouldSetupConstraints = true
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var textMessage: TextMessageProtocol! {
        didSet {
            superInsets = .vertical(4) + (
                textMessage.isIncoming
                    ? .left(16) + .right(8)
                    : .left(8) + .right(16)
            )
            
            let textColor: UIColor = textMessage.isIncoming
                ? .plainText
                : .accentText
            
            textLabel.text = textMessage.text
            textLabel.textColor = textColor
            
            usernameLabel.isHidden = !textMessage.isIncoming
            usernameLabel.textColor = .plainText
            usernameLabel.text = "User Userov" // TODO: user name by id
            
            timeLabel.text = timeFormatter.string(from: textMessage.date)
            timeLabel.textColor = textColor
            
            if textMessage.text.count < 12 {
                timeLabel.top(to: textLabel, textLabel.bottomAnchor, offset: -timeLabel.bounds.height)
            }
        }
    }
    
    func loadMessage(_ message: MessageProtocol) {
        self.textMessage = message as? TextMessageProtocol
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
        Bundle.main.loadNibNamed("MessageTextContent", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Methods
    
    override func updateConstraints() {
        if shouldSetupConstraints {
            edgesToSuperview(insets: superInsets)
            
            shouldSetupConstraints = false
        }
        super.updateConstraints()
    }
    
}
