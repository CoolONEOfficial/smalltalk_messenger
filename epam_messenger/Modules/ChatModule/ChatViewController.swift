//
//  ChatViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 08.03.2020.
//

import UIKit
import Firebase
import Ballcap
import MessageKit
import InputBarAccessoryView

protocol ChatViewControllerProtocol {
    func performUpdates(keepOffset: Bool)
    func didInsertMessage()
}

class ChatViewController: MessagesViewController {
    var viewModel: ChatViewModelProtocol!
    
    let primaryColor = UIColor(red: 87/255, green: 85/255, blue: 218/255, alpha: 1)
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        
        title = viewModel.getChatModel().name
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        configureMessageInputBar()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .init(width: 50, height: 35)
            layout.setMessageIncomingAvatarSize(CGSize.init(width: 35, height: 35))
            layout.setMessageOutgoingMessagePadding(.init(top: 0, left: 0, bottom: -5, right: 0))
            layout.setMessageIncomingMessagePadding(.init(top: 0, left: 0, bottom: -5, right: 0))
        }
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = primaryColor
        messageInputBar.sendButton.setTitleColor(primaryColor, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            primaryColor.withAlphaComponent(0.3),
            for: .highlighted
        )
        
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.tintColor = primaryColor
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        configureInputBarItems()
    }
    
    private func configureInputBarItems() {
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.image = #imageLiteral(resourceName: "ic_up")
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 15
        messageInputBar.layer.cornerRadius = 18
        messageInputBar.inputTextView.font = messageInputBar.inputTextView.font.withSize(15)
        messageInputBar.middleContentViewPadding.right = -36
        let charCountButton = InputBarButtonItem()
            .configure {
                $0.title = "0/140"
                $0.contentHorizontalAlignment = .right
                $0.setTitleColor(UIColor(white: 0.6, alpha: 1), for: .normal)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
                $0.setSize(CGSize(width: 50, height: 25), animated: false)
        }.onTextViewDidChange { (item, textView) in
            item.title = "\(textView.text.count)/140"
            let isOverLimit = textView.text.count > 140
            item.inputBarAccessoryView?.shouldManageSendButtonEnabledState = !isOverLimit // Disable automated management when over limit
            if isOverLimit {
                item.inputBarAccessoryView?.sendButton.isEnabled = false
            }
            let color = isOverLimit ? .red : UIColor(white: 0.6, alpha: 1)
            item.setTitleColor(color, for: .normal)
        }
        let bottomItems = [.flexibleSpace, charCountButton]
        messageInputBar.middleContentViewPadding.bottom = 8
        messageInputBar.setStackViewItems(bottomItems, forStack: .bottom, animated: false)
        
        // This just adds some more flare
        messageInputBar.sendButton
            .onEnabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.imageView?.backgroundColor = self.primaryColor
                })
        }.onDisabled { item in
            UIView.animate(withDuration: 0.3, animations: {
                item.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
            })
        }
    }
    
    // MARK: - Helpers
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return !isPreviousMessageSameDay(at: indexPath)
    }
    
    func isPreviousMessageSameDay(at indexPath: IndexPath) -> Bool {
        let messageList = viewModel.messageList()
        guard indexPath.section - 1 >= 0 else { return false }
        return Calendar.current.isDate(
            messageList[indexPath.section].sentDate,
            inSameDayAs: messageList[indexPath.section - 1].sentDate
        )
    }
    
    func isLastSectionVisible() -> Bool {
        
        let messageList = viewModel.messageList()
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        let messageList = viewModel.messageList()
        guard indexPath.section + 1 < messageList.count else { return false }
        return messageList[indexPath.section].userId == messageList[indexPath.section + 1].userId
    }
    
    func isNextMessageSameSenderAndTime(at indexPath: IndexPath) -> Bool {
        let messageList = viewModel.messageList()
        
        return isNextMessageSameSender(at: indexPath)
            && messageList[indexPath.section].sentDate.distance(
                to: messageList[indexPath.section + 1].sentDate
            ).isLess(
                than: 5.0 * 60.0
        )
    }
}

public struct Sender: SenderType {
    public let senderId: String
    
    public let displayName: String
}

extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return Sender(senderId: "0", displayName: "TestUser")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return viewModel.messageList().count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return viewModel.messageList()[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(
            string: MessageKit24HourDateFormatter.shared.string(from: message.sentDate),
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ])
    }
}

extension ChatViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message)
            ? primaryColor
            : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // Cells are reused, so only add a button here once. For real use you would need to
        // ensure any subviews are removed if not needed
        accessoryView.subviews.forEach { $0.removeFromSuperview() }
        accessoryView.backgroundColor = .clear
        
        let shouldShow = Int.random(in: 0...10) == 0
        guard shouldShow else { return }
        
        let button = UIButton(type: .infoLight)
        button.tintColor = primaryColor
        accessoryView.addSubview(button)
        button.frame = accessoryView.bounds
        button.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
        accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
        accessoryView.backgroundColor = primaryColor.withAlphaComponent(0.3)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let tail: MessageStyle.TailCorner =
            isFromCurrentSender(message: message)
                ? .bottomRight
                : .bottomLeft
        
        return isNextMessageSameSenderAndTime(at: indexPath)
            ? .bubble
            : .bubbleTail(tail, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if isFromCurrentSender(message: message) {
            avatarView.isHidden = true
        } else {
            var image: UIImage
            
            switch message.sender.senderId {
            case "0":
                image = #imageLiteral(resourceName: "Dan-Leonard")
            case "1":
                image = #imageLiteral(resourceName: "Steven-Deutsch")
            case "2":
                image = #imageLiteral(resourceName: "Wu-Zhong")
            default:
                image = #imageLiteral(resourceName: "Tim-Cook")
            }
            
            avatarView.set(avatar: Avatar.init(image: image, initials: "Test initials"))
            avatarView.isHidden = isNextMessageSameSender(at: indexPath)
            avatarView.layer.borderWidth = 0
//            avatarView.layer.borderColor = primaryColor.cgColor
//            avatarView.layer.bounds = CGRect.init(x: 0, y: 0, width: 35, height: 35)
//            avatarView.layer.cornerRadius = 35 / 2
        }
    }
}

extension ChatViewController: MessagesLayoutDelegate {
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isNextMessageSameSenderAndTime(at: indexPath) ? 0 : 5
    }
}

extension ChatViewController: ChatViewControllerProtocol {
    
    func performUpdates(keepOffset: Bool) {
        if keepOffset {
            messagesCollectionView.reloadDataAndKeepOffset()
        } else {
            messagesCollectionView.reloadData()
        }
    }
    
    func didInsertMessage() {
        let messageList = viewModel.messageList()
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
}

// MARK: - MessageInputBarDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        
        guard let sendStr = components.first as? String else {
            didSendMessage(result: false, components: components)
            return
        }
        
        viewModel.sendMessage(
            messageModel: MessageModel(
                documentId: nil,
                text: sendStr,
                userId: 0,
                timestamp: Timestamp()
        )) { result in
            self.didSendMessage(result: result, components: components)
        }
        
    }
    
    private func didSendMessage(result: Bool, components: [Any]) {
        self.messageInputBar.sendButton.stopAnimating()
        self.messageInputBar.inputTextView.placeholder = "Aa"
        if result {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
}
