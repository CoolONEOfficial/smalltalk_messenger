//
//  ChatListViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import UIKit
import Firebase
import Ballcap
import IGListKit

protocol ChatListViewControllerProtocol {
    func performUpdates()
    func reloadCell(_ chatModel: ChatModel)
}

class ChatListViewController: UIViewController {
    var viewModel: ChatListViewModelProtocol!
    
    let collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        view.backgroundColor = .none
        
        return view
    }()
    
    lazy var adapter: ListAdapter = {
      return ListAdapter(
      updater: ListAdapterUpdater(),
      viewController: self,
      workingRangeSize: 0)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        
        title = "ChatList"
        
        view.addSubview(collectionView)
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension ChatListViewController: ChatListViewControllerProtocol {
    func performUpdates() {
        adapter.performUpdates(animated: true)
    }
    
    func reloadCell(_ chatModel: ChatModel) {
        adapter.reloadObjects([chatModel])
    }
}

extension ChatListViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.chatList()
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ChatListSectionController(viewModel: viewModel)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
