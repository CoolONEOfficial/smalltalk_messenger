//
//  PaginatedTableVIew.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 07.04.2020.
//

import UIKit
import FirebaseFirestore

class PaginatedSectionedTableView<KeyT: Hashable, ElementT: Equatable>: PaginatedTableView<ElementT> {
    
    // MARK: - Vars
    
    var data: [SectionArray<KeyT, ElementT>] = [] {
        didSet {
            flattenData = data.map { $0.elements }.reduce([], +)
        }
    }
    
    var groupingBy: ((ElementT) -> KeyT)!
    var sortedBy: ((KeyT, KeyT) -> Bool)!

    // MARK: - Init
    
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
        animateRowAndSectionChanges(
            oldData: oldData as! [SectionArray<KeyT, ElementT>],
            newData: self.data
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
    
    override func scrollToBottom(animated: Bool) {
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
            animated: animated
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
