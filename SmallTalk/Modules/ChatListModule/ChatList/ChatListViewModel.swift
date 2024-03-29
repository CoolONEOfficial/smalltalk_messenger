//
//  ChatListViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import Foundation
import Firebase
import AlgoliaSearchClient
import CodableFirebase

protocol ChatListViewModelProtocol: ViewModelProtocol {
    func goToChat(_ chatId: String)
    func goToChatDetails(_ chatModel: ChatModel)
    func goToChatCreate()
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
    func listenUserListData(
        _ userList: [String],
        completion: @escaping ([UserModel]?) -> Void
    )
    func listenUserData(
        _ userId: String,
        completion: @escaping (UserModel?) -> Void
    )
    func getChatData(
        _ chatId: String,
        completion: @escaping (ChatModel?) -> Void
    )
    func deleteSelectedChats(_ chatList: [ChatModel])
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
    
    func goToChatCreate() {
        guard let router = router as? ChatListRouter else { return }
        
        router.showChatCreate()
    }
    
    func goToChat(_ chatId: String) {
        guard let router = router as? ChatRouter else { return }
        
        router.showChat(chatId: chatId)
    }
    
    func goToChatDetails(_ chatModel: ChatModel) {
        guard let router = router as? ChatRouter else { return }
        
        router.showChatDetails(chatModel, from: nil)
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
    
    func deleteSelectedChats(_ chatList: [ChatModel]) {
        for chatModel in chatList {
            firestoreService.deleteChat(chat: chatModel)
        }
    }
    
    func listenUserListData(_ userList: [String], completion: @escaping ([UserModel]?) -> Void) {
        firestoreService.listenUserListData(userList, completion: completion)
    }
    
    func listenUserData(_ userId: String, completion: @escaping (UserModel?) -> Void) {
        firestoreService.listenUserData(userId, completion: completion)
    }
    
    func getChatData(_ chatId: String, completion: @escaping (ChatModel?) -> Void) {
        firestoreService.getChatData(chatId, completion: completion)
    }
}
