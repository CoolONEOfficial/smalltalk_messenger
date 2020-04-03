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
    func deleteChat(
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
    func deleteChat(
        _ chat: ChatProtocol,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        deleteChat(chat, completion: completion)
    }
}

class ChatListViewModel: ChatListViewModelProtocol {
    let router: RouterProtocol
    let viewController: ChatListViewControllerProtocol
    let firestoreService: FirestoreService = .init()
    let algoliaService: AlgoliaService = .init()
    
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
        return AssemblyBuilder().createChatModule(router: router, chat: chat)
    }
    
    func deleteChat(_ chat: ChatProtocol, completion: @escaping (Bool) -> Void = {_ in}) {
        firestoreService.deleteChat(
            chatDocumentId: chat.documentId,
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
