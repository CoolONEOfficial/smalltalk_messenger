//
//  ChatTableViewDataSource.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import Foundation
import FirebaseUI

class ChatTableViewDataSource: FUIFirestoreTableViewDataSource {
    
    // MARK: - Init
    
    internal enum ChangeType {
        case insert
        case delete
    }
    
    override init(collection: FUIBatchedArray, populateCell: @escaping (UITableView, IndexPath, DocumentSnapshot) -> UITableViewCell) {
        super.init(collection: collection, populateCell: populateCell)
        
        itemsObservation = collection.observe(\FUIBatchedArray.items) { _, _ in
            let oldDateKeys = self.messageItems.map({ $0.key }).removingDuplicates()
            self.oldSectionCounts = self.messageItems.map({ $0.value.count })
            self.updateMessages()
            let newDateKeys = self.messageItems.map({ $0.key }).removingDuplicates()
            
            let diff = Array(Set(oldDateKeys).symmetricDifference(newDateKeys))
            
            let diffType: ChangeType = newDateKeys.count > oldDateKeys.count
                ? .insert
                : .delete
            
            if diffType == .insert {
                self.oldSectionCounts = self.messageItems.map({ $0.value.count })
            }
            
            let diffKeys = diff.map { mKey -> Int in
                
                var actualKeys: [Date]!
                switch diffType {
                case .insert:
                    actualKeys = newDateKeys
                case .delete:
                    actualKeys = oldDateKeys
                }
                
                let dKey = actualKeys.firstIndex(where: { $0 == mKey })!
                
                return dKey
            }
            
            self.chatTableView.lastSectionsChange = (
                change: IndexSet(diffKeys),
                type: diffType
            )
        }
    }
    
    // MARK: - Vars
    
    private var chatTableView: ChatTableView {
        return tableView as! ChatTableView
    }
    
    internal var messageItems: [(key: Date, value: [MessageProtocol])] = []
    
    internal var oldSectionCounts: [Int]!
    
    private var itemsObservation: NSKeyValueObservation!
    
    // MARK: - Override UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return messageItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageItems[section].value.count
    }
    
    // MARK: - Functions
    
    internal func updateMessages() {
        let messages = self.items.map { mSnapshot in
            return MessageModel.fromSnapshot(mSnapshot)!
        }
        
        messageItems = Dictionary(grouping: messages) { mMessage in
            return mMessage.timestamp.dateValue().midnight
        }.sorted { l, r in
            return (l.key as Date).compare(r.key as Date) == .orderedAscending
        }
    }
    
    internal func transformIndexPath(_ indexPath: IndexPath) -> IndexPath {
        var checkedMessages = 0
        for (mSectionId, mSectionCount) in oldSectionCounts.enumerated() {
            checkedMessages += mSectionCount
            if checkedMessages > indexPath.item {
                return IndexPath(row: indexPath.item - checkedMessages + mSectionCount, section: mSectionId)
            }
        }
        
        fatalError()
    }
    
    internal func transformIndexPathList(_ indexPathList: [IndexPath]) -> [IndexPath] {
        return indexPathList.map({ transformIndexPath($0) })
    }
    
}
