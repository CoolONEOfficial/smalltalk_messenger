//
//  PaginatedTableView.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.04.2020.
//

import UIKit
import FirebaseFirestore

protocol PaginatedTableViewDelegate: UITableViewDelegate {
    func didUpdateElements()
}

extension PaginatedTableViewDelegate {
    func didUpdateElements() {}
}

private let queryCount = 40
private let paginationQueryCount = 30
private let paginationTriggerAreaHeight: CGFloat = 250
private let slowPaginationCellsOffset = 5
private let fastPaginationCellsOffset = 1
private let fastScroll: CGFloat = 2000

/// Custom UITableView with realtime updates and pagination support.
///
/// - Warning: Don't override `delegate`, use `paginatedDelegate`
class PaginatedTableView<ElementT: Equatable>: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Vars
    
    /// Active if scroll at start.
    var dataAtStart = false
    
    /// Active if scroll at end.
    var dataAtEnd = false
    
    /// Flatten data.
    var flattenData: [ElementT] = []
    
    weak var paginatedDelegate: PaginatedTableViewDelegate?
    
    var baseQuery: FireQuery!
    var initialPosition: InitialPosition!
    var cellForRowAt: ((IndexPath) -> UITableViewCell)!
    var querySideTransform: ((ElementT) -> Any)!
    var fromSnapshot: ((_ snapshot: DocumentSnapshot) -> ElementT?)!
    var startElement: ElementT!
    var endElement: ElementT!
    
    private var sideGroup: DispatchGroup? = .init()
    private var deleteSideGroup: DispatchGroup? = .init()
    
    var paginationLock = false
    private var previousContentOffset: CGFloat = 0
    private var previousScrollMoment: Date = Date()
    
    var listener: ListenerRegistration! {
        didSet {
            oldValue?.remove()
        }
    }
    
    /// UITableView initial position
    enum InitialPosition {
        case top
        case bottom
    }
    
    // MARK: - Init
    
    /**
     Initializes a new PaginatedTableView.
     
     - Parameters:
     - baseQuery: Firebase query with collection which will be displayed
     - initialPosition: UITableView scroll position at start
     - cellForRowAt: Closure returns UITableViewCell from given indexPath
     - querySideTransform: Closure returns start and/or end of `baseQuery` that will be diplayed
     - fromSnapshot: Closure returns parsed model from given snapshot
     
     - Returns: New PaginatedTableView.
     */
    init(
        baseQuery: FireQuery,
        initialPosition: InitialPosition,
        cellForRowAt: @escaping ((IndexPath) -> UITableViewCell),
        querySideTransform: @escaping ((ElementT) -> Any),
        fromSnapshot: @escaping ((_ snapshot: DocumentSnapshot) -> ElementT?)
    ) {
        super.init(frame: .init(), style: .plain)
        self.baseQuery = baseQuery
        self.initialPosition = initialPosition
        self.cellForRowAt = cellForRowAt
        self.querySideTransform = querySideTransform
        self.fromSnapshot = fromSnapshot
        
        sideGroup?.enter()
        baseQuery.limit(to: 1).addSnapshotListener(snapshotListener { [weak self] elements in
            guard let self = self,
                let elements = elements else { return }
            
            self.startElement = elements.first
            self.sideGroup?.leave()
        })
        
        sideGroup?.enter()
        baseQuery.limit(toLast: 1).addSnapshotListener(snapshotListener { [weak self] elements in
            guard let self = self,
                let elements = elements else { return }
            
            self.endElement = elements.last
            self.sideGroup?.leave()
        })
        
        deleteSideGroup?.notify(queue: .main) {
            self.sideGroup = nil
            self.deleteSideGroup = nil
        }
        
        commonInit()
        
        switch initialPosition {
        case .top:
            loadAtStart()
        case .bottom:
            paginationLock = true
            loadAtEnd {
                self.updateElements(
                    $0,
                    unlockPagination: false
                )
                self.scrollToBottom { _ in
                    self.unlockPagination()
                }
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
        
        didScroll()
    }
    
    private func didScroll() {
        if let visiblePathList = indexPathsForVisibleRows,
            !paginationLock {
            let oldMoment = Date()
            let elapsed = oldMoment.timeIntervalSince(previousScrollMoment)
            let distance = (contentOffset.y - previousContentOffset)
            let velocity = (elapsed == 0) ? 0 : abs(distance / CGFloat(elapsed))
            
            let cellsOffset = velocity > fastScroll
                ? fastPaginationCellsOffset
                : slowPaginationCellsOffset
            
            if !dataAtStart, topOffset < paginationTriggerAreaHeight,
                previousContentOffset >= contentOffset.y,
                let lastVisiblePath = visiblePathList.last {
                paginationLock = true
                
                let flattened = flattenData
                
                if let visibleIndex = flattened.firstIndex(where: { $0 == elementAt(lastVisiblePath) }) {
                    let endMessageIndex: Int
                    let visibleCellCount: Int = visiblePathList.count
                    
                    if !dataAtEnd, visibleIndex + cellsOffset < flattened.count {
                        endMessageIndex = visibleIndex + cellsOffset
                    } else {
                        endMessageIndex = flattened.count - 1
                    }
                    
                    dataAtStart = false
                    dataAtEnd = false
                    
                    let limit = paginationQueryCount + visibleCellCount
                    listener = baseQuery
                        .end(at: [querySideTransform(flattened[endMessageIndex])])
                        .limit(toLast: limit)
                        .addSnapshotListener(snapshotListener { elements in
                            guard self.topOffset < paginationTriggerAreaHeight,
                                let elements = elements else {
                                    self.unlockPagination()
                                    return
                            }
                            
                            self.deleteSideGroup?.enter()
                            if let sideGroup = self.sideGroup {
                                sideGroup.notify(queue: .main) {
                                    self.deleteSideGroup?.leave()
                                    self.didScrollTop(
                                        elements: elements,
                                        limit: limit
                                    )
                                }
                            } else {
                                self.didScrollTop(
                                    elements: elements,
                                    limit: limit
                                )
                            }
                        })
                }
            } else if !dataAtEnd && bottomOffset < paginationTriggerAreaHeight,
                previousContentOffset <= contentOffset.y,
                let firstVisiblePath = visiblePathList.first {
                paginationLock = true
                
                if let visibleIndex = flattenData.firstIndex(where: { $0 == elementAt(firstVisiblePath) }) {
                    let startMessageIndex: Int
                    let visibleCellCount: Int = visiblePathList.count
                    
                    if !dataAtStart, visibleIndex - cellsOffset >= 0 {
                        startMessageIndex = visibleIndex - cellsOffset
                    } else {
                        startMessageIndex = 0
                    }
                    
                    dataAtStart = false
                    dataAtEnd = false
                    
                    let limit = paginationQueryCount + visibleCellCount
                    listener = baseQuery
                        .start(at: [querySideTransform(flattenData[startMessageIndex])])
                        .limit(to: limit)
                        .addSnapshotListener(snapshotListener { elements in
                            guard self.bottomOffset < paginationTriggerAreaHeight,
                                let elements = elements else {
                                    self.unlockPagination()
                                    return
                            }
                            
                            self.deleteSideGroup?.enter()
                            if let sideGroup = self.sideGroup {
                                sideGroup.notify(queue: .main) {
                                    self.deleteSideGroup?.leave()
                                    self.didScrollBottom(
                                        elements: elements,
                                        limit: limit
                                    )
                                }
                            } else {
                                self.didScrollBottom(
                                    elements: elements,
                                    limit: limit
                                )
                            }
                        })
                }
            }
            
            previousScrollMoment = oldMoment
            previousContentOffset = contentOffset.y
        }
    }
    
    private func didScrollTop(
        elements: [ElementT],
        limit: Int
    ) {
        if elements.contains(self.startElement) {
            self.loadAtStart()
        } else {
            self.updateElements(
                elements
            )
        }
    }
    
    private func didScrollBottom(
        elements: [ElementT],
        limit: Int
    ) {
        if elements.contains(self.endElement) {
            self.loadAtEnd()
        } else {
            self.updateElements(
                elements
            )
        }
    }
    
    private func snapshotListener(
        completion: (([ElementT]?) -> Void)? = nil
    ) -> ((QuerySnapshot?, Error?) -> Void) {
        { snapshot, err in
            guard err == nil else {
                debugPrint("Error while get snapshot")
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
    
    func updateElements(elements: [ElementT]?) {
        updateElements(elements)
    }
    
    func updateData(_ elements: [ElementT]) -> Any {
        let oldData = self.flattenData
        self.flattenData = elements
        return oldData
    }
    
    func animateChanges(_ oldData: Any) {
        animateRowChanges(
            oldData: oldData as! [ElementT],
            newData: self.flattenData,
            deletionAnimation: .fade,
            insertionAnimation: .fade
        )
    }
    
    func updateElements(
        _ elements: [ElementT]?,
        animate: Bool = true,
        scrollView: UIScrollView? = nil,
        unlockPagination: Bool = true
    ) {
        if let elements = elements {
            let oldData = updateData(elements)
            
            if animate {
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    if unlockPagination {
                        self.unlockPagination()
                    }
                }
                animateChanges(oldData)
                CATransaction.commit()
            } else {
                reloadData()
                if unlockPagination {
                    self.unlockPagination()
                }
            }
            
            paginatedDelegate?.didUpdateElements()
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
    
    private func unlockPagination() {
        paginationLock = false
    }
    
    // MARK: - UITableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        flattenData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellForRowAt(indexPath)
    }
    
    // MARK: - Helpers
    
    /**
     Scroll to last element of UITableView.
     
     - Parameter animated: Use animation for scroll.
     */
    func scrollToBottom(completion: ((Bool) -> Void)? = nil) {
        guard !flattenData.isEmpty else {
            return
        }
        
        let lastIndex = flattenData.count - 1
        scrollToRow(
            at: IndexPath(
                row: lastIndex,
                section: 0
            ),
            at: .none,
            completion: completion
        )
    }
    
    func scrollToRow(
        at indexPath: IndexPath,
        at scrollPosition: UITableView.ScrollPosition,
        completion: ((Bool) -> Void)?
    ) {
        UIView.animate(withDuration: 0.3, animations: {
            super.scrollToRow(at: indexPath, at: scrollPosition, animated: false)
        }, completion: completion)
    }
    
    public func elementAt(_ indexPath: IndexPath) -> ElementT {
        return elementAt(indexPath.row)
    }
    
    public func elementAt(_ index: Int) -> ElementT {
        return flattenData[index]
    }
    
    // MARK: - PaginatedDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        paginatedDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        paginatedDelegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        paginatedDelegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        paginatedDelegate?.tableView?(tableView, shouldBeginMultipleSelectionInteractionAt: indexPath) ?? false
    }
    
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        paginatedDelegate?.tableView?(tableView, didBeginMultipleSelectionInteractionAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        paginatedDelegate?.tableView?(tableView, contextMenuConfigurationForRowAt: indexPath, point: point)
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        paginatedDelegate?.tableView?(tableView, willPerformPreviewActionForMenuWith: configuration, animator: animator)
    }
    
    // MARK: - Helpers
    
    var topOffset: CGFloat {
        contentOffset.y + safeAreaInsets.top
    }
    
    var bottomOffset: CGFloat {
        contentSize.height
            - contentOffset.y
            - bounds.height
            + contentInset.bottom
            + safeAreaInsets.bottom
    }
}
