//
//  ChatListViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

protocol ChatListViewModelProtocol: ViewModelProtocol {
    func goToChat(_ chatModel: ChatModel)
    func firestoreQuery() -> Query
    func createChatPreview(_ chatModel: ChatModel) -> UIViewController
}

class ChatListViewModel: ChatListViewModelProtocol {
    let router: RouterProtocol
    let viewController: ChatListViewControllerProtocol
    let firestoreService: FirestoreService = FirestoreService()
    
    init(
        router: RouterProtocol,
        viewController: ChatListViewControllerProtocol
    ) {
        self.router = router
        self.viewController = viewController
    }
    
    func goToChat(_ chatModel: ChatModel) {
        router.showChat(chatModel)
    }
    
    func firestoreQuery() -> Query {
        return firestoreService.chatListQuery
    }
    
    func didChatLoad(snapshot: DocumentSnapshot, cell: ChatCell) {
        if let chatModel = ChatModel.fromSnapshot(snapshot) {
            cell.loadChatModel(chatModel)
        }
    }
    
    func createChatPreview(_ chatModel: ChatModel) -> UIViewController {
        return AssemblyBuilder().createChatModule(router: router, chatModel: chatModel)
    }
}
