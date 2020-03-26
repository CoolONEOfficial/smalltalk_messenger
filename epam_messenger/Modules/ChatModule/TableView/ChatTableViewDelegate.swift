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
                var allText = ""
                for kind in self.tableView.chatDataSource.messageAt(indexPath).kind {
                    switch kind {
                    case .text(let text):
                        allText += text
                    default: break
                    }
                }
                pasteBoard.string = allText
            }
            
            let savePhoto = UIAction(
                title: "Save to camera roll",
                image: UIImage(systemName: "square.and.arrow.down")
            ) { _ in
                
                if let cell = tableView.cellForRow(at: indexPath) as? MessageCell,
                    let imageContent = cell.contentStack.subviews.first(where: { $0 is MessageImageContent }) as? MessageImageContent,
                    let image = imageContent.imageView.image {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
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
            
            var actions = [
                copy, delete
            ]
            
            let message = self.tableView.chatDataSource.messageAt(indexPath)
            if message.kind.filter({ content in
                if case .image = content {
                    return true
                }
                return false
            }).count == 1 {
                actions.insert(savePhoto, at: 1)
            }
            
            return UIMenu(title: "", children: [
                UIMenu(title: "", options: .displayInline, children: actions),
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
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = messageCell.message.isIncoming
            ? .plainBackground
            : .accent
        
        let bounds = messageCell.contentStack.bounds.inset(
            by: .init(
                top: -(messageCell.contentStack.subviews.first as! MessageCellContentProtocol).topMargin,
                left: 0,
                bottom: -(messageCell.contentStack.subviews.last as! MessageCellContentProtocol).bottomMargin,
                right: 0
            )
        )
        
        parameters.visiblePath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: MessageCell.cornerRadius
        )
        
        return UITargetedPreview(view: messageCell.contentStack, parameters: parameters)
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return makeTargetedPreview(for: configuration)
    }
    
    // MARK: Floating bottom button
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !bottomScrollAnimationsLock else {
            return
        }
        
        let hidden = scrollView.contentSize.height
            - scrollView.contentOffset.y
            - scrollView.bounds.height < 100
        if self.floatingBottomButton.isHidden != hidden {
            bottomScrollAnimationsLock = true
            
            self.floatingBottomButton.alpha = hidden ? 1.0 : 0.0
            self.inputBar.separatorLine.alpha = hidden ? 1.0 : 0.0
            
            if !hidden { // show before alpha transition
                self.floatingBottomButton.isHidden = hidden
                self.inputBar.separatorLine.isHidden = hidden
            }
            
            UIView.transition(
                with: floatingBottomButton,
                duration: 0.5,
                options: .transitionCrossDissolve,
                animations: {
                    self.floatingBottomButton.alpha = hidden ? 0.0 : 1.0
                    self.inputBar.separatorLine.alpha = hidden ? 0.0 : 1.0
            }) { _ in
                self.bottomScrollAnimationsLock = false
                
                if hidden { // hide after alpha transition
                    self.floatingBottomButton.isHidden = hidden
                    self.inputBar.separatorLine.isHidden = hidden
                }
                
                self.scrollViewDidScroll(scrollView)
            }
        }
    }
    
    // MARK: - Edit mode
    
    private func didSelectionChange() {
        let rowsSelected = !(tableView.indexPathsForSelectedRows?.isEmpty ?? true)
        
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
        for indexPath in tableView.indexPathsForSelectedRows! {
            let message = self.tableView.chatDataSource.messageAt(indexPath)
            
            viewModel.deleteMessage(message) { _ in
                self.didSelectionChange()
            }
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
        inputBar.hideSideStacks()
    }
    
    @objc private func disableEditMode() {
        didSelectionChange()
        tableView.setEditing(false, animated: true)
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        inputBar.setMiddleContentView(inputBar.inputTextView, animated: true)
        inputBar.showSideStacks()
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
