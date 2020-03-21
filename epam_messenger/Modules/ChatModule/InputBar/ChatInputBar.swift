//
//  ChatInputBar.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import Foundation
import InputBarAccessoryView

class ChatInputBar: InputBarAccessoryView {
    
    // MARK: - Vars
    
    let attachButton = InputBarButtonItem()
    
    static let defaultLeftStackWidth: CGFloat = 30
    static let defaultRightStackWidth: CGFloat = 30
    static let sendImageInset: CGFloat = 6
    static let sendButtonInsets: UIEdgeInsets = .init(
        top: sendImageInset, left: sendImageInset,
        bottom: sendImageInset, right: sendImageInset
    )
    static let attachImageInset: CGFloat = 2
    static let attachButtonInsets: UIEdgeInsets = .init(
        top: attachImageInset, left: attachImageInset,
        bottom: attachImageInset, right: attachImageInset
    )
    static let stacksPadding: CGFloat = 4
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = .accent
        
        setupInputTextView()
        setupLeftStack()
        setupRightStack()
        separatorLine.backgroundColor = .plainBackground
        backgroundView.backgroundColor = .systemBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLeftStack() {
        setupAttachButton()
        setLeftStackViewWidthConstant(to: ChatInputBar.defaultLeftStackWidth, animated: false)
        setStackViewItems([attachButton], forStack: .left, animated: false)
        padding.left = ChatInputBar.stacksPadding
        middleContentViewPadding.left = ChatInputBar.stacksPadding
    }
    
    func setupRightStack() {
        setupSendButton()
        setRightStackViewWidthConstant(to: ChatInputBar.defaultRightStackWidth, animated: false)
        setStackViewItems([sendButton], forStack: .right, animated: false)
        padding.right = ChatInputBar.stacksPadding
        middleContentViewPadding.right = ChatInputBar.stacksPadding
    }
    
    func setupSendButton() {
        sendButton.imageEdgeInsets = ChatInputBar.sendButtonInsets
        sendButton.setSize(CGSize(width: 30, height: 30), animated: false)
        sendButton.image = UIImage(systemName: "arrow.up")
        sendButton.tintColor = UIColor.lightText.withAlphaComponent(1)
        
        sendButton.contentHorizontalAlignment = .fill
        sendButton.contentVerticalAlignment = .fill
        sendButton.contentMode = .scaleToFill
        sendButton.title = nil
        
        sendButton.layer.backgroundColor = UIColor.accent.cgColor
        sendButton.layer.cornerRadius = 15
    }
    
    func setupAttachButton() {
        attachButton.imageEdgeInsets = ChatInputBar.attachButtonInsets
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.image = UIImage(systemName: "paperclip")
        attachButton.tintColor = .plainIcon
        
        attachButton.contentHorizontalAlignment = .fill
        attachButton.contentVerticalAlignment = .fill
        attachButton.contentMode = .scaleToFill
        attachButton.title = nil
        attachButton.addTarget(self, action: #selector(didClickAttachButton), for: .touchUpInside)
    }
    
    func setupInputTextView() {
        inputTextView.backgroundColor = .systemBackground
        inputTextView.textContainerInset = UIEdgeInsets(top: 6, left: 8, bottom: 4, right: 44)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 6, left: 12, bottom: 4, right: 33)
        inputTextView.placeholderLabel.text = "Message..."
        inputTextView.textColor = .white
        inputTextView.font = UIFont.preferredFont(forTextStyle: .body).withSize(16)
        inputTextView.layer.borderColor = UIColor.plainBackground.cgColor
        inputTextView.layer.borderWidth = 1.3
        inputTextView.layer.cornerRadius = 16.0
        inputTextView.layer.masksToBounds = true
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    // MARK: - Events
    
    @objc func didClickAttachButton() {
        
    }
    
    // MARK: - Side stacks visibility functions
    
    public func hideSideStacks() {
        setRightStackViewWidthConstant(to: 0, animated: true)
        setLeftStackViewWidthConstant(to: 0, animated: true)
        sendButton.imageEdgeInsets = .zero
        attachButton.imageEdgeInsets = .zero
    }
    
    public func showSideStacks() {
        sendButton.imageEdgeInsets = ChatInputBar.sendButtonInsets
        attachButton.imageEdgeInsets = ChatInputBar.attachButtonInsets
        setRightStackViewWidthConstant(to: ChatInputBar.defaultRightStackWidth, animated: true)
        setLeftStackViewWidthConstant(to: ChatInputBar.defaultLeftStackWidth, animated: true)
        padding.right = ChatInputBar.stacksPadding
        middleContentViewPadding.right = ChatInputBar.stacksPadding
    }
}
