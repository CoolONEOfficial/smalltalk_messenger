//
//  PaginatedTableVIew.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 07.04.2020.
//

import UIKit
import FirebaseFirestore

struct SectionArray<KeyT: Equatable, ElementT: Equatable>: Equatable, Collection {

    let elements: [ElementT]
    let key: KeyT

    typealias Index = Int

    var startIndex: Int {
        return elements.startIndex
    }

    var endIndex: Int {
        return elements.endIndex
    }
    
    public func at(i: Int) -> ElementT {
        return elements[i]
    }

    subscript(i: Int) -> ElementT {
        return elements[i]
    }

    public func index(after i: Int) -> Int {
        return elements.index(after: i)
    }

    static func == (fst: SectionArray, snd: SectionArray) -> Bool {
        return fst.key == snd.key
    }
}

protocol PaginatedTableViewDelegate: UITableViewDelegate {}

private let paginationQueryCount = 30
private let queryCount = 40

class PaginatedTableView<KeyT: Hashable, ElementT: Equatable>: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var dataAtStart = false
    var dataAtEnd = false
    var data: [SectionArray<KeyT, ElementT>] = [] {
        didSet {
            flattenData = data.map { $0.elements }.reduce([], +)
        }
    }
    var flattenData: [ElementT] = []
    
    var paginationLock = false
    var lastContentOffset: CGFloat = 0
    
    var listener: ListenerRegistration! {
        didSet {
            oldValue?.remove()
        }
    }

    weak var paginatedDelegate: PaginatedTableViewDelegate?
    
    var baseQuery: FireQuery!
    var initialPosition: InitialPosition!
    var cellForRowAt: ((IndexPath) -> UITableViewCell)!
    var querySideTransform: ((ElementT) -> Any)!
    var groupingBy: ((ElementT) -> KeyT)!
    var sortedBy: ((KeyT, KeyT) -> Bool)!
    var fromSnapshot: ((_ snapshot: DocumentSnapshot) -> ElementT?)!
    
    enum InitialPosition {
        case top
        case bottom
    }
    
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
        super.init(frame: .init(), style: .plain)
        self.baseQuery = baseQuery
        self.initialPosition = initialPosition
        self.cellForRowAt = cellForRowAt
        self.querySideTransform = querySideTransform
        self.groupingBy = groupingBy
        self.sortedBy = sortedBy
        self.fromSnapshot = fromSnapshot
        commonInit()
        
        switch initialPosition {
        case .top:
            loadAtStart { self.updateElements(
                elements: $0,
                unlockPagination: $0?.count == queryCount
            ) }
        case .bottom:
            paginationLock = true
            loadAtEnd {
                self.updateElements(
                    elements: $0,
                    unlockPagination: $0?.count == queryCount
                )
                self.scrollToBottom(animated: true)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        delegate = self
        dataSource = self
    }
    
    // MARK: - UITableViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        paginatedDelegate?.scrollViewDidScroll?(scrollView)
        
        didScroll(scrollView)
    }
    
    private func didScroll(
        _ scrollView: UIScrollView,
        afterUnlock: Bool = false
    ) {
        if let visiblePathList = indexPathsForVisibleRows,
            !paginationLock {
            if !dataAtStart,
                scrollView.contentOffset.y + safeAreaInsets.top < 250,
                lastContentOffset >= scrollView.contentOffset.y,
                let lastVisiblePath = visiblePathList.last {
                paginationLock = true

                let flattened = flattenData

                if let visibleIndex = flattened.firstIndex(where: { $0 == elementAt(lastVisiblePath) }) {
                    dataAtStart = false
                    dataAtEnd = false

                    let endMessageIndex: Int
                    let visibleCellCount: Int = visiblePathList.count
                    if visibleIndex + 5 < flattened.count {
                        endMessageIndex = visibleIndex + 5
                    } else {
                        endMessageIndex = flattened.count - 1
                    }
                    listener = baseQuery
                        .end(at: [querySideTransform(flattened[endMessageIndex])])
                        .limit(toLast: paginationQueryCount + visibleCellCount)
                        .addSnapshotListener(snapshotListener { elements in
                            if elements?.count == paginationQueryCount + visibleCellCount {
                                self.updateElements(
                                    elements: elements,
                                    scrollView: afterUnlock ? nil : scrollView
                                )
                            } else {
                                self.loadAtStart()
                            }
                        })
                }
            } else if !dataAtEnd,
                scrollView.contentSize.height
                    - scrollView.contentOffset.y
                    - scrollView.bounds.height
                    + scrollView.contentInset.bottom
                    + safeAreaInsets.bottom < 250,
                lastContentOffset <= scrollView.contentOffset.y,
                let firstVisiblePath = visiblePathList.first {
                paginationLock = true

                let flattened = flattenData

                if let visibleIndex = flattened.firstIndex(where: { $0 == elementAt(firstVisiblePath) }) {
                    dataAtStart = false
                    dataAtEnd = false

                    let startMessageIndex: Int
                    let visibleCellCount: Int = visiblePathList.count
                    if visibleIndex - 5 >= 0 {
                        startMessageIndex = visibleIndex - 5
                    } else {
                        startMessageIndex = 0
                    }
                    listener = baseQuery
                        .start(at: [querySideTransform(flattened[startMessageIndex])])
                        .limit(to: paginationQueryCount + visibleCellCount)
                        .addSnapshotListener(snapshotListener { elements in
                            if elements?.count == paginationQueryCount + visibleCellCount {
                                self.updateElements(
                                    elements: elements,
                                    scrollView: afterUnlock ? nil : scrollView
                                )
                            } else {
                                self.loadAtEnd()
                            }
                        })
                }
            }
            
            lastContentOffset = scrollView.contentOffset.y
        }
    }
    
    private func snapshotListener(
        completion: (([ElementT]?) -> Void)? = nil
    ) -> ((QuerySnapshot?, Error?) -> Void) {
        { snapshot, err in
            guard err == nil else {
                debugPrint("Error while get ")
                return
            }
            
            let completion = completion ?? self.updateElements
            if let snapshot = snapshot {
                completion(snapshot.documents.map { self.fromSnapshot($0)! })
            } else {
                completion(nil)
            }
        }
    }
    
    private func parseListChat(
        _ snapshot: QuerySnapshot?,
        _ err: Error?,
        _ completion: @escaping ([MessageModel]?) -> Void
    ) {
        guard err == nil else {
            debugPrint("Error while get ")
            return
        }
        
        if let snapshot = snapshot {
            completion(snapshot.documents.map { MessageModel.fromSnapshot($0)! })
        }
    }
    
    func updateElements(elements: [ElementT]?) {
        updateElements(elements: elements, animate: true)
    }
    
    func updateElements(
        elements: [ElementT]?,
        animate: Bool = true,
        scrollView: UIScrollView? = nil,
        unlockPagination: Bool = true
    ) {
        if let elements = elements {
            let oldData = self.data
            
            self.data = Dictionary(grouping: elements, by: groupingBy)
                .sorted { self.sortedBy($0.key, $1.key) }
                .map { SectionArray<KeyT, ElementT>(elements: $0.value, key: $0.key) }
            
            if animate {
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    if unlockPagination {
                        self.unlockPagination(scrollView)
                    }
                }
                animateRowAndSectionChanges(
                    oldData: oldData,
                    newData: self.data
                )
                CATransaction.commit()
            } else {
                reloadData()
                if unlockPagination {
                    self.unlockPagination(scrollView)
                }
            }
            
//            if dataAtEnd {
//                scrollToBottom(animated: true)
//                if flattenData.count >= 2, MessageModel.checkMerge(
//                    flattenData[flattenData.count - 1],
//                    flattenData[flattenData.count - 2]
//                ) {
//                    let section = data.count - 1
//                    let lastRow = data[section].elements.count - 1
//                    reloadRows(
//                        at: [
//                            .init(row: lastRow - 1, section: section)
//                        ],
//                        with: .automatic
//                    )
//                }
//
//            }
        }
    }
    
    func loadAtStart(completion: (([ElementT]?) -> Void)? = nil) {
        dataAtStart = true
        dataAtEnd = false
        
        listener = baseQuery.limit(to: queryCount)
            .addSnapshotListener(
                snapshotListener(
                    completion: completion ?? updateElements
            ))
    }
    
    func loadAtEnd(completion: (([ElementT]?) -> Void)? = nil) {
        dataAtStart = false
        dataAtEnd = true
        
        listener = baseQuery.limit(toLast: queryCount)
            .addSnapshotListener(
                snapshotListener(
                    completion: completion ?? updateElements
            ))

    }
    
    func unlockPagination(_ scrollView: UIScrollView? = nil) {
        paginationLock = false
        
        if let scrollView = scrollView {
            didScroll(scrollView, afterUnlock: true)
        }
    }
    
    // MARK: - UITableView DataSource & Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellForRowAt(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        paginatedDelegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        paginatedDelegate?.tableView?(tableView, heightForHeaderInSection: section) ?? UITableView.automaticDimension
    }
    
    // MARK: - Helpers
    
    func scrollToBottom(animated: Bool) {
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
    
    public func elementAt(_ indexPath: IndexPath) -> ElementT {
        return data[indexPath.section].elements[indexPath.row]
    }
    
    public func keyAt(_ indexPath: IndexPath) -> KeyT {
        return keyAt(indexPath.section)
    }
    
    public func keyAt(_ section: Int) -> KeyT {
        return data[section].key
    }
}
