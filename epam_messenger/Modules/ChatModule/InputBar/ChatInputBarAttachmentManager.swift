//
//  ChatInputBarAttachmentManager.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 22.03.2020.
//

import Foundation
import InputBarAccessoryView
import BSImagePicker
import Photos

extension ChatViewController: AttachmentManagerDelegate {
    
    // MARK: - AttachmentManagerDelegate
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    func setAttachmentManager(active: Bool) {
        let topStackView = inputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
            updateTableViewInset(attachmentManager.attachmentView.bounds.height)
            
            if floatingBottomButton.isHidden {
                tableView.scrollToBottom(animated: true)
            }
            
            inputBar.setStackViewItems([inputBar.sendButton], forStack: .right, animated: true)
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            updateTableViewInset(-attachmentManager.attachmentView.bounds.height)
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
            inputBar.inputTextViewDidChange()
            
            if floatingBottomButton.isHidden {
                tableView.scrollToBottom(animated: true)
            }
        }
    }
}
