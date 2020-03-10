//
//  TableSectionController.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 09.03.2020.
//

import Foundation
import UIKit
import IGListKit

class ChatListSectionController: ListSectionController {
    let viewModel: ChatListViewModelProtocol
    
    init(viewModel: ChatListViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var currentChatModel: ChatModel?
    
    override func didUpdate(to object: Any) {
      guard let chatModel = object as? ChatModel else {
        return
      }
      currentChatModel = chatModel
    }
    
    override func numberOfItems() -> Int {
        return 1 // One hero will be represented by one cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard
          let context = collectionContext
          else {
            return .zero
        }
        let width = context.containerSize.width
        return CGSize(width: width, height: 65)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let nibName = String(describing: ChatCell.self)
        
        guard let ctx = collectionContext, let chatModel = currentChatModel else {
            return UICollectionViewCell()
        }
        
        let cell = ctx.dequeueReusableCell(withNibName: nibName,
                                           bundle: nil,
                                           for: self,
                                           at: index)
        guard let chatCell = cell as? ChatCell else {
            debugPrint("cell isn't ChatCell")
            return cell
        }
        chatCell.loadChatModel(chatModel)
        return chatCell
    }
    
    override func didSelectItem(at index: Int) {
        guard let chatModel = currentChatModel else {
            debugPrint("currentChatModel is nil")
            return
        }
        
        viewModel.goToChat(chatModel)
    }
    
}
