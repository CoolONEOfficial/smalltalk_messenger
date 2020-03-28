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
        
        // Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (attributes, range, stop) in
            
            let substring = attributedText.attributedSubstring(from: range)
            //let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            //print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        inputBar.inputTextView.text = String()
        
        didStartSendMessage()
        
        viewModel.sendMessage(
            attachments: attachmentManager.attachments,
            messageText: text
        ) {_ in
            self.didEndSendMessage()
        }
        
        inputBar.invalidatePlugins()
        updateTableViewInset()
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        // Adjust content insets
        //print(size)
        //tableView.contentInset.bottom = size.height + 300 // keyboard size estimate
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
        let inputBar = self.inputBar
        
        inputBar.setStackViewItems([
            text.isEmpty
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
