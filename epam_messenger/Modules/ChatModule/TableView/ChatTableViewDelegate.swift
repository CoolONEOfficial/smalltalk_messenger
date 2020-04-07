//
//  ChatTableViewDelegate.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

extension ChatViewController: UITableViewDelegate {
    
    func scrollToBottom(animated: Bool) {
        guard !data.isEmpty else {
            return
        }
        
        let lastIndex = data.count - 1
        let lastSections = data[lastIndex]
        tableView.scrollToRow(
            at: IndexPath(
                row: lastSections.elements.count - 1,
                section: lastIndex
            ),
            at: .none,
            animated: animated
        )
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = dayAt(section)
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
                for kind in self.messageAt(indexPath).kind {
                    switch kind {
                    case .text(let text):
                        allText += text
                    default: break
                    }
                }
                pasteBoard.string = allText
            }
            
            let forward = UIAction(
                title: "Forward",
                image: UIImage(systemName: "arrowshape.turn.up.right")
            ) { _ in
                let messageModel = self.messageAt(indexPath)
                self.presentForwardController()
                self.forwardMessages = [messageModel]
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
                    self.messageAt(indexPath)
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
            
            var actions: [UIAction] = []
            
            let message = self.messageAt(indexPath)
            
            if message.kind.filter({ content in
                if case .image = content {
                    return true
                }
                return false
            }).count == 1 {
                actions.append(savePhoto)
            }
            if message.kind.contains(where: { content in
                if case .text = content {
                    return true
                }
                return false
            }) {
                actions.append(copy)
            }
            
            actions.append(forward)
            
            if !message.isIncoming {
                actions.append(delete)
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
        parameters.backgroundColor = messageCell.message.backgroundColor
        
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
    
    func listChatListener(messages: [MessageModel]?) {
        listChatListener(messages: messages, scrollView: nil)
    }
    
    func unlockPagination(_ scrollView: UIScrollView? = nil) {
        self.paginationLock = false
        
        if let scrollView = scrollView {
            self.didScroll(scrollView, afterUnlock: true)
        }
    }
    
    func listChatListener(
        messages: [MessageModel]?,
        scrollView: UIScrollView? = nil,
        animate: Bool = true,
        unlockPagination: Bool = true
    ) {
        if let messages = messages {
            let oldData = self.data
            
            self.data = Dictionary(grouping: messages) { $0.date.midnight }
                .sorted { ($0.key as Date).compare($1.key as Date) == .orderedAscending }
                .map { SectionArray(elements: $0.value, key: $0.key) }
            
            if animate {
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    if unlockPagination {
                        self.unlockPagination(scrollView)
                    }
                }
                tableView.animateRowAndSectionChanges(
                    oldData: oldData,
                    newData: self.data
                )
                CATransaction.commit()
            } else {
                tableView.reloadData()
                if unlockPagination {
                    self.unlockPagination(scrollView)
                }
            }
            
            if dataAtEnd {
                scrollToBottom(animated: true)
                let flattened = flattenData
                if flattened.count >= 2, MessageModel.checkMerge(
                    flattened[flattened.count - 1],
                    flattened[flattened.count - 2]
                ) {
                    let section = data.count - 1
                    let lastRow = data[section].elements.count - 1
                    tableView.reloadRows(
                        at: [
                            .init(row: lastRow - 1, section: section)
                        ],
                        with: .automatic
                    )
                }
                
            }
        }
    }
    
    func loadChatAtStart() {
        dataAtStart = true
        dataAtEnd = false
        
        listener = viewModel.listChatAtStart(completion: listChatListener)
    }
    
    func loadChatAtEnd(completion: (([MessageModel]?) -> Void)? = nil) {
        dataAtStart = false
        dataAtEnd = true
        
        listener = viewModel.listChatAtEnd(completion: completion ?? listChatListener)
    }
    
    func didScroll(_ scrollView: UIScrollView, afterUnlock: Bool = false) {
        if let visiblePathList = tableView.indexPathsForVisibleRows,
            !paginationLock {
            if !dataAtStart,
                scrollView.contentOffset.y < 250,
                lastContentOffset >= scrollView.contentOffset.y,
                let lastVisiblePath = visiblePathList.last {
                paginationLock = true
                
                debugPrint("chat top scroll")
                
                let flattened = flattenData
                
                if let visibleIndex = flattened.firstIndex(where: { $0 == messageAt(lastVisiblePath) }) {
                    dataAtStart = false
                    dataAtEnd = false
                    
                    let endMessageIndex: Int
                    let visibleCellCount: Int = visiblePathList.count
                    if visibleIndex + 5 < flattened.count {
                        endMessageIndex = visibleIndex + 5
                    } else {
                        endMessageIndex = flattened.count - 1
                    }
                    listener = viewModel.listChat(
                        end: Timestamp(date: flattened[endMessageIndex].date),
                        visibleCellCount: visibleCellCount
                    ) { messages in
                        if messages?.count == FirestoreService.chatPaginationQueryCount + visibleCellCount {
                            debugPrint("chat load pagination")
                            self.listChatListener(
                                messages: messages,
                                scrollView: afterUnlock ? nil : scrollView
                            )
                        } else {
                            debugPrint("chat load start")
                            self.loadChatAtStart()
                        }
                    }
                }
            } else if !dataAtEnd,
                scrollView.contentSize.height
                    - scrollView.contentOffset.y
                    - scrollView.bounds.height < 250,
                lastContentOffset <= scrollView.contentOffset.y,
                let firstVisiblePath = visiblePathList.first {
                paginationLock = true
                
                debugPrint("chat bottom scroll")

                let flattened = flattenData

                if let visibleIndex = flattened.firstIndex(where: { $0 == messageAt(firstVisiblePath) }) {
                    dataAtStart = false
                    dataAtEnd = false
                    
                    let startMessageIndex: Int
                    let visibleCellCount: Int = visiblePathList.count
                    if visibleIndex - 5 >= 0 {
                        startMessageIndex = visibleIndex - 5
                    } else {
                        startMessageIndex = 0
                    }
                    listener = viewModel.listChat(
                        start: Timestamp(date: flattened[startMessageIndex].date),
                        visibleCellCount: visibleCellCount
                    ) { messages in
                        if let messagesCount = messages?.count {
                            if messagesCount == FirestoreService.chatPaginationQueryCount + visibleCellCount {
                                debugPrint("chat load pagination")
                                self.listChatListener(
                                    messages: messages,
                                    scrollView: afterUnlock ? nil : scrollView
                                )
                            } else {
                                debugPrint("chat load end")
                                self.loadChatAtEnd()
                            }
                        }
                    }
                }
            }
        }
        
        if !bottomScrollAnimationsLock {
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
        
        lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll(scrollView)
    }
    
    // MARK: - Edit mode
    
    private func didSelectionChange() {
        let messagesSelected = !(tableView.indexPathsForSelectedRows?.isEmpty ?? true)
        let myMessagesSelected = !(
            tableView.indexPathsForSelectedRows?
                .map { messageAt($0).userId }
                .contains { $0 != Auth.auth().currentUser!.uid }
                ?? true
        )
        
        deleteButton.isEnabled = myMessagesSelected
        forwardButton.isEnabled = messagesSelected
        
        title = messagesSelected
            ? "Selected \(tableView.indexPathsForSelectedRows!.count) messages"
            : defaultTitle
        
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
    }
    
    @objc internal func deleteSelectedMessages() {
        for indexPath in tableView.indexPathsForSelectedRows! {
            let message = messageAt(indexPath)
            
            viewModel.deleteMessage(message) { _ in
                self.didSelectionChange()
            }
        }
    }
    
    @objc internal func deleteChat() {
        viewModel.deleteChat() { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    internal func presentForwardController() {
        let forwardController = viewModel.createForwardViewController(forwardDelegate: self)
        let navigationController = UINavigationController(rootViewController: forwardController)
        navigationController.view.tintColor = .accent
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc internal func forwardSelectedMessages() {
        presentForwardController()
        forwardMessages = tableView!.indexPathsForSelectedRows!.map { messageAt($0) }
    }
    
    private func enableEditMode() {
        tableView.setEditing(true, animated: true)
        didSelectionChange()
        
        inputBar.setMiddleContentView(editStack, animated: false)
        inputBar.middleContentViewPadding.right = 0
        inputBar.hideSideStacks()
    }
    
    @objc private func disableEditMode() {
        tableView.setEditing(false, animated: true)
        didSelectionChange()
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
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        if !tableView.isEditing {
            enableEditMode()
        }
        return true
    }
    
}

extension ChatViewController: ForwardDelegateProtocol {
    
    func didSelectChat(_ chatModel: ChatModel) {
        if forwardMessages != nil {
            for message in forwardMessages {
                viewModel.forwardMessage(chatModel, message) { result in
                    if result && self.viewModel.chat.documentId != chatModel.documentId {
                        self.viewModel.goToChat(chatModel)
                    }
                }
            }
            forwardMessages = nil
            disableEditMode()
        }
    }
    
}
