//
//  ChatTableView+InputBarAccessoryViewDelegate.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import Foundation
import InputBarAccessoryView

protocol ChatInputBarDelegate: AnyObject {
    func didActionImageTap()
    func didVoiceMessageRecord(data: Data)
}

extension ChatViewController: ChatInputBarDelegate {
    
    func didActionImageTap() {
        imagePickerService.pickImages { image in
            self.attachmentManager.handleInput(of: image)
        }
    }
    
    func didVoiceMessageRecord(data: Data) {
        didStartSendMessage()
        
        viewModel.sendMessage(
            attachments: [ .data(data) ],
            messageText: nil
        ) { _ in
            self.didEndSendMessage()
        }
    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        didStartSendMessage()

        if viewModel.chat.documentId == nil {
            viewModel.createChat { [weak self] err in
                guard let self = self else { return }
                guard err == nil else {
                    return
                }
                self.didChatLoad()
                self.sendMessage(text)
            }
        } else {
            sendMessage(text)
        }
    }
    
    private func sendMessage(_ text: String) {
        viewModel.sendMessage(
            attachments: attachmentManager.attachments,
            messageText: text
        ) {_ in
            self.didEndSendMessage()
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        // Adjust content insets
        //print(size)
        //updateTableViewInset()
        //tableView.contentInset.bottom = size.height + 300 // keyboard size estimate
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
        if isTyping == false {
            isTyping = true
            
            viewModel.startTypingCurrentUser()
        }
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.didEndTyping), object: nil)
        self.perform(#selector(self.didEndTyping), with: nil, afterDelay: 0.5)
        
        guard !(inputBar.middleContentView?.isHidden ?? true) else { return }
        
        let inputBar = self.inputBar
        
        inputBar.setStackViewItems([
            text.isEmpty && attachmentManager.attachments.isEmpty
                ? inputBar.voiceButton
                : inputBar.sendButton
        ], forStack: .right, animated: false)
        
        guard autocompleteManager.currentSession != nil, autocompleteManager.currentSession?.prefix == "#" else { return }
        // Load some data asyncronously for the given session.prefix
        DispatchQueue.global(qos: .default).async {
            // fake background loading task
            var array: [AutocompleteCompletion] = []
            //            for _ in 1...10 {
            //                array.append(AutocompleteCompletion(text: Lorem.word()))
            //            }
            //            sleep(1)
            DispatchQueue.main.async { [weak self] in
                //self?.asyncCompletions = array
                self?.autocompleteManager.reloadData()
            }
        }
    }
    
    @objc private func didEndTyping() {
        isTyping = false
        viewModel.endTypingCurrentUser()
    }
}
