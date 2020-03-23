//
//  ChatTableView+InputBarAccessoryViewDelegate.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import Foundation
import InputBarAccessoryView

protocol ChatInputBarDelegate {
    func didActionImageTap()
    func didVoiceMessageRecord(data: Data)
}

extension ChatViewController: ChatInputBarDelegate {
    
    func didActionImageTap() {
        viewModel.pickImages(viewController: self) { image in
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
        
        viewModel.sendMessage(
            attachments: attachmentManager.attachments,
            messageText: text
        ) {_ in
            self.didEndSendMessage()
        }
        
        inputBar.invalidatePlugins()
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        // Adjust content insets
        //print(size)
        //updateTableViewInset()
        //tableView.contentInset.bottom = size.height + 300 // keyboard size estimate
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
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
}
