//
//  ChatInputBar.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import Foundation
import InputBarAccessoryView

class ChatInputBar: InputBarAccessoryView {
    
    // MARK: - Init
    
    static let defaultRightWidth = CGFloat(38)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        tintColor = .accent
        
        inputTextView.backgroundColor = .systemBackground
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 44)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 36)
        inputTextView.placeholderLabel.text = "Message..."
        inputTextView.textColor = .white
        inputTextView.font = UIFont.preferredFont(forTextStyle: .body)
        inputTextView.layer.borderColor = UIColor.plainBackground.cgColor
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.cornerRadius = 16.0
        inputTextView.layer.masksToBounds = true
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        setRightStackViewWidthConstant(to: ChatInputBar.defaultRightWidth, animated: false)
        setStackViewItems([sendButton, InputBarButtonItem.fixedSpace(2)], forStack: .right, animated: false)
        sendButton.imageView?.backgroundColor = tintColor
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        sendButton.image = #imageLiteral(resourceName: "ic_up")
        sendButton.title = nil
        sendButton.imageView?.layer.cornerRadius = 16
        sendButton.backgroundColor = .clear
        middleContentViewPadding.right = -ChatInputBar.defaultRightWidth
        separatorLine.backgroundColor = .plainBackground
        backgroundView.backgroundColor = .systemBackground
        blurView.isHidden = false
    }
}
