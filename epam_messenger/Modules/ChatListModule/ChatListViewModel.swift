//
//  ChatListViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import Foundation
import Firebase
import InstantSearchClient
import CodableFirebase

protocol ChatListViewModelProtocol: ViewModelProtocol {
    func goToChat(_ chatModel: ChatModel)
    func firestoreQuery() -> FireQuery
    func searchChats(
        _ searchString: String,
        completion: @escaping SearchChatsCompletion
    )
    func searchMessages(
        _ searchString: String,
        completion: @escaping SearchMessagesCompletion
    )
    func createChatPreview(_ chat: ChatProtocol) -> UIViewController
    func leaveChat(
        _ chat: ChatProtocol,
        completion: @escaping (Bool) -> Void
    )
    func userListData(
        _ userList: [String],
        completion: @escaping ([UserModel]?) -> Void
    )
    func userData(
        _ userId: String,
        completion: @escaping (UserModel?) -> Void
    )
    func chatData(
        _ chatId: String,
        completion: @escaping (ChatModel?) -> Void
    )
}

extension ChatListViewModelProtocol {
    func leaveChat(
        _ chat: ChatProtocol,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        leaveChat(chat, completion: completion)
    }
}

class ChatListViewModel: ChatListViewModelProtocol {
    let router: RouterProtocol
    let viewController: ChatListViewControllerProtocol
    let firestoreService: FirestoreServiceProtocol
    let algoliaService: AlgoliaServiceProtocol
    
    init(
        router: RouterProtocol,
        viewController: ChatListViewControllerProtocol,
        firestoreService: FirestoreServiceProtocol = FirestoreService(),
        algoliaService: AlgoliaServiceProtocol = AlgoliaService()
    ) {
        self.router = router
        self.viewController = viewController
        self.firestoreService = firestoreService
        self.algoliaService = algoliaService
    }
    
    func goToChat(_ chatModel: ChatModel) {
        guard let router = router as? ChatRouter else { return }
        
        router.showChat(chatModel)
    }
    
    func firestoreQuery() -> FireQuery {
        return firestoreService.chatListQuery
    }
    
    func searchChats(
        _ searchString: String,
        completion: @escaping SearchChatsCompletion
    ) {
        return algoliaService.searchChats(searchString, completion: completion)
    }
    
    func searchMessages(
        _ searchString: String,
        completion: @escaping SearchMessagesCompletion
    ) {
        return algoliaService.searchMessages(searchString, completion: completion)
    }
    
    func createChatPreview(_ chat: ChatProtocol) -> UIViewController {
        return AssemblyBuilder().createChat(router: router, chat: chat)
    }
    
    func leaveChat(_ chat: ChatProtocol, completion: @escaping (Bool) -> Void = {_ in}) {
        firestoreService.leaveChat(
            chatId: chat.documentId,
            completion: completion
        )
    }
    
    func userListData(_ userList: [String], completion: @escaping ([UserModel]?) -> Void) {
        firestoreService.userListData(userList, completion: completion)
    }
    
    func userData(_ userId: String, completion: @escaping (UserModel?) -> Void) {
        firestoreService.userData(userId, completion: completion)
    }
    
    func chatData(_ chatId: String, completion: @escaping (ChatModel?) -> Void) {
        firestoreService.chatData(chatId, completion: completion)
    }
}
