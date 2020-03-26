//
//  ChatTableView.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import UIKit
import Firebase

class ChatTableView: UITableView {
    
    // MARK: - Vars
    
    public var chatDataSource: ChatTableViewDataSource {
        return dataSource as! ChatTableViewDataSource
    }
    
    internal var lastSectionsChange: (type: ChatTableViewDataSource.ChangeType, change: IndexSet)?
    
    var messageDelegate: MessageCellDelegate?
    
    // MARK: - Override TableView
    
    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        let transformedPaths = chatDataSource.transformIndexPathList(indexPaths)
        super.reloadRows(at: transformedPaths, with: animation)
    }
    
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        guard !indexPaths.isEmpty else {
            return
        }
        
        let transformedPaths = chatDataSource.transformIndexPathList(indexPaths)
        let singlePath = transformedPaths.count == 1
        let firstPath = transformedPaths.first!
        
        if let change = lastSectionsChange,
            change.type == .insert,
            !change.change.isEmpty {
            super.insertSections(change.change, with: .fade)
            lastSectionsChange = nil
        }
        
        super.insertRows(
            at: transformedPaths,
            with: singlePath
                ? .bottom
                : animation
        )
        
        if singlePath,
            firstPath.row > 0 {
            let prevPath = IndexPath(
                row: firstPath.row - 1,
                section: firstPath.section
            )
            
            let prevMessage = chatDataSource.messageAt(prevPath)
            let currentMessage = chatDataSource.messageAt(firstPath)
            
            if MessageModel.checkMerge(left: prevMessage, right: currentMessage) {
                super.reloadRows(
                    at: [prevPath],
                    with: .fade
                )
            }
        }
    }
    
    override func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        guard !indexPaths.isEmpty else {
            return
        }
        
        let transformedPaths = chatDataSource.transformIndexPathList(indexPaths)
        
        if let change = lastSectionsChange,
            change.type == .delete,
            !change.change.isEmpty {
            super.deleteSections(change.change, with: .automatic)
            lastSectionsChange = nil
        }
        
        super.deleteRows(at: transformedPaths, with: .fade)
        
        let firstPath = transformedPaths.first!
        guard chatDataSource.messageItems.count > firstPath.section else {
            return
        }
        let messagesCount = chatDataSource.messageItems[firstPath.section].value.count
        
        let prevPath = IndexPath(
            row: firstPath.row > 0
                ? firstPath.row - 1
                : 0,
            section: firstPath.section
        )
        let nextPath = IndexPath(
            row: firstPath.row + transformedPaths.count > messagesCount
                ? messagesCount - 1
                : firstPath.row + transformedPaths.count,
            section: firstPath.section
        )
        
        let reloadPaths = prevPath != nextPath && prevPath != firstPath
            ? [prevPath, nextPath]
            : [nextPath]
        
        super.reloadRows(
            at: reloadPaths,
            with: .fade
        )
        
        delegate?.didDeleteRow()
    }
    
    override func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        fatalError() // messages doesnt move
    }
    
    // MARK: Custom bind
    
    func bind(toFirestoreQuery query: Query, populateCell: @escaping (UITableView, IndexPath) -> MessageCell) -> ChatTableViewDataSource {
        let dataSource = ChatTableViewDataSource(query: query) { tableView, indexPath, _ in
            let cell = populateCell(tableView, indexPath)
            cell.delegate = self.messageDelegate
            return cell
        }
        dataSource.bind(to: self)
        return dataSource
    }
    
    // MARK: - Helpers
    
    func scrollToBottom(animated: Bool) {
        guard !chatDataSource.messageItems.isEmpty else {
            return
        }
        
        let lastIndex = chatDataSource.messageItems.count - 1
        let lastItem = chatDataSource.messageItems[lastIndex]
        scrollToRow(at: IndexPath(row: lastItem.value.count - 1, section: lastIndex), at: .bottom, animated: animated)
    }
}
