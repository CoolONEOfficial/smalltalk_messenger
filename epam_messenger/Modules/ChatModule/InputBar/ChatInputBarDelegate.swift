//
//  ChatTableView+InputBarAccessoryViewDelegate.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import Foundation
import InputBarAccessoryView

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
        inputBar.invalidatePlugins()

        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        
        viewModel.sendMessage(text) {_ in
            inputBar.sendButton.stopAnimating()
            inputBar.inputTextView.placeholder = "Aa"
            
            self.tableView.scrollToBottom()
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        // Adjust content insets
        //print(size)
        //tableView.contentInset.bottom = size.height + 300 // keyboard size estimate
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
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
