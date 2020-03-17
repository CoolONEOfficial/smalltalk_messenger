//
//  ChatTableViewDelegate.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import UIKit

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = self.tableView.chatDataSource.dayAt(section)
        let dateString = Message24HourDateFormatter.shared.string(from: date)
        
        let label = DateHeaderLabel()
        label.text = dateString
        
        let containerView = UIView()
        
        containerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        return containerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // MARK: - Context menu
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard !tableView.isEditing else {
            return nil
        }
        
        let identifier = NSMutableArray(array: [
            indexPath.row,
            indexPath.section
        ])
        let config = UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
            let copy = UIAction(
                title: "Copy",
                image: UIImage(systemName: "doc.on.doc")
            ) { _ in
                let pasteBoard = UIPasteboard.general
                pasteBoard.string = (self.tableView.chatDataSource
                    .messageAt(indexPath) as! TextMessageProtocol).text
            }
            
            let delete = UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                self.viewModel.deleteMessage(
                    self.tableView.chatDataSource.messageAt(indexPath)
                )
            }
            
            let other = UIAction(
                title: "Other",
                image: UIImage(systemName: "ellipsis.circle")
            ) { _ in
                self.enableEditMode()
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                self.didSelectionChange()
            }
            
            return UIMenu(title: "", children: [
                UIMenu(title: "", options: .displayInline, children: [
                    copy, delete
                ]),
                other
            ])
        }
        
        return config
    }
    
    func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        let identifier = configuration.identifier as! NSArray
        let indexPath = IndexPath(
            row: identifier[0] as! Int,
            section: identifier[1] as! Int
        )
        
        let messageCell: MessageCell = tableView.cellForRow(at: indexPath) as! MessageCell
        
        switch messageCell.messageContent {
        case let textContent as MessageTextContent:
            let parameters = UIPreviewParameters()
            parameters.backgroundColor = textContent.textMessage.isIncoming
                ? .plainBackground
                : .accent
            
            let bounds = textContent.textLabel.bounds.inset(
                by: .init(
                    top: -5,
                    left: -5,
                    bottom: -5,
                    right: -5
                )
            )
           
            parameters.visiblePath = UIBezierPath(roundedRect: bounds, cornerRadius: 16)
            
            return UITargetedPreview(view: textContent.textLabel, parameters: parameters)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    // MARK: - Edit mode
    
    private func didSelectionChange() {
        let rowsSelected = tableView.indexPathsForSelectedRows != nil
        
        title = rowsSelected
            ? "Selected \(tableView.indexPathsForSelectedRows!.count) messages"
            : viewModel.getChatModel().name

        navigationItem.leftBarButtonItem = .init(
            title: "Delete chat",
            style: .plain,
            target: self,
            action: #selector(deleteChat)
        )
        
        navigationItem.rightBarButtonItem = .init(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(disableEditMode)
        )
        
        deleteButton.isEnabled = rowsSelected
        forwardButton.isEnabled = rowsSelected
    }
    
    @objc internal func deleteSelectedMessages() {
        for mIndexPath in tableView.indexPathsForSelectedRows! {
            let mMessage = self.tableView.chatDataSource.messageAt(mIndexPath)
            
            viewModel.deleteMessage(mMessage)
        }
    }
    
    @objc internal func deleteChat() {
        // TODO: delete chat
    }
    
    @objc internal func forwardSelectedMessages() {
        // TODO: forward messages
    }
    
    private func enableEditMode() {
        tableView.setEditing(true, animated: true)
        didSelectionChange()
        
        inputBar.setMiddleContentView(stack, animated: false)
        inputBar.middleContentViewPadding.right = 0
        inputBar.setRightStackViewWidthConstant(to: 0, animated: false)
    }
    
    @objc private func disableEditMode() {
        didSelectionChange()
        tableView.setEditing(false, animated: true)
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        inputBar.setMiddleContentView(inputBar.inputTextView, animated: true)
        inputBar.middleContentViewPadding.right = -ChatInputBar.defaultRightWidth
        inputBar.setRightStackViewWidthConstant(to: ChatInputBar.defaultRightWidth, animated: false)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            didSelectionChange()
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            didSelectionChange()
        }
    }

    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        enableEditMode()
    }

    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }

}
