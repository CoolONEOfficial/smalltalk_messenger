//
//  PaginatedTableVIew.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 07.04.2020.
//

import UIKit
import FirebaseFirestore

/// Custom UITableView with realtime updates, sections grouping and pagination support.
///
/// - Warning: Don't override `delegate`, use `paginatedDelegate`
class PaginatedSectionedTableView<KeyT: Hashable, ElementT: Equatable>: PaginatedTableView<ElementT> {
    
    // MARK: - Vars
    
    /// Sectioned data.
    var data: [SectionArray<KeyT, ElementT>] = [] {
        didSet {
            flattenData = data.map { $0.elements }.reduce([], +)
        }
    }
    
    var groupingBy: ((ElementT) -> KeyT)!
    var sortedBy: ((KeyT, KeyT) -> Bool)!

    // MARK: - Init
    
    /**
    Initializes a new PaginatedSectionedTableView.

    - Parameters:
       - baseQuery: Firebase query with collection which will be displayed
       - initialPosition: UITableView scroll position at start
       - cellForRowAt: Closure returns UITableViewCell from given indexPath
       - querySideTransform: Closure returns start and/or end of `baseQuery` that will be diplayed
       - groupingBy: Closure returns variable that will be used for grouping models by sections
       - sortedBy: Closure that will be used for sort sections
       - fromSnapshot: Closure returns parsed model from given snapshot

    - Returns: New PaginatedSectionedTableView.
    */
    init(
        baseQuery: FireQuery,
        initialPosition: InitialPosition,
        cellForRowAt: @escaping ((IndexPath) -> UITableViewCell),
        querySideTransform: @escaping ((ElementT) -> Any),
        groupingBy: @escaping ((ElementT) -> KeyT),
        sortedBy: @escaping ((KeyT, KeyT) -> Bool),
        fromSnapshot: @escaping ((_ snapshot: DocumentSnapshot) -> ElementT?)
    ) {
        self.groupingBy = groupingBy
        self.sortedBy = sortedBy
        
        super.init(
            baseQuery: baseQuery,
            initialPosition: initialPosition,
            cellForRowAt: cellForRowAt,
            querySideTransform: querySideTransform,
            fromSnapshot: fromSnapshot
        )
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - PaginatedTableView
    
    override func updateData(_ elements: [ElementT]) -> Any {
        let oldData = self.data
        self.data = Dictionary(grouping: elements, by: groupingBy)
            .sorted { self.sortedBy($0.key, $1.key) }
            .map { SectionArray<KeyT, ElementT>(elements: $0.value, key: $0.key) }
        return oldData
    }
    
    override func animateChanges(_ oldData: Any) {
        if !dataAtStart && contentOffset.y < 1 {
            contentOffset.y = 1
        }
        
        animateRowAndSectionChanges(
            oldData: oldData as! [SectionArray<KeyT, ElementT>],
            newData: self.data,
            rowDeletionAnimation: .top,
            rowInsertionAnimation: .bottom
        )
    }
    
    // MARK: - UITableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].elements.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        paginatedDelegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        paginatedDelegate?.tableView?(tableView, heightForHeaderInSection: section) ?? UITableView.automaticDimension
    }
    
    // MARK: - Helpers
    
    /**
      Scroll to last element of last section of UITableView.

      - Parameter animated: Use animation for scroll.
    */
    override func scrollToBottom(completion: ((Bool) -> Void)? = nil) {
        guard !data.isEmpty else {
            return
        }
        
        let lastIndex = data.count - 1
        let lastSections = data[lastIndex]
        scrollToRow(
            at: IndexPath(
                row: lastSections.elements.count - 1,
                section: lastIndex
            ),
            at: .none,
            completion: completion
        )
    }
    
    public func keyAt(_ indexPath: IndexPath) -> KeyT {
        return keyAt(indexPath.section)
    }
    
    public func keyAt(_ section: Int) -> KeyT {
        return data[section].key
    }
    
    public override func elementAt(_ indexPath: IndexPath) -> ElementT {
        return data[indexPath.section].elements[indexPath.row]
    }
}
