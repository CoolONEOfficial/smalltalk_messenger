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
    
    // MARK: - Default transform
    
    override func layoutSubviews() {
        transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
    }
    
    // MARK: - Override TableView
    
    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        let transformedPaths = chatDataSource.transformIndexPathList(indexPaths)
        super.reloadRows(at: transformedPaths, with: animation)
    }
    
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        let transformedPaths = chatDataSource.transformIndexPathList(indexPaths)
        
        if let change = lastSectionsChange,
            change.type == .insert,
            !change.change.isEmpty {
            super.insertSections(change.change, with: animation)
            lastSectionsChange = nil
        }

        super.insertRows(at: transformedPaths, with: animation)
    }
    
    override func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        let transformedPaths = chatDataSource.transformIndexPathList(indexPaths)
        
        if let change = lastSectionsChange,
            change.type == .delete,
            !change.change.isEmpty {
            super.deleteSections(change.change, with: animation)
            lastSectionsChange = nil
        }

        super.deleteRows(at: transformedPaths, with: animation)
    }
    
    override func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        fatalError() // messages doesnt move
    }
    
    // MARK: Custom bind
    
    func bind(toFirestoreQuery query: Query, populateCell: @escaping (UITableView, IndexPath) -> UITableViewCell) -> ChatTableViewDataSource {
        let dataSource = ChatTableViewDataSource(query: query) { tableView, indexPath, _ in
            return populateCell(tableView, indexPath)
        }
        dataSource.bind(to: self)
        return dataSource
    }
}
