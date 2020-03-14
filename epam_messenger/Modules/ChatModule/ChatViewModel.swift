//
//  ChatViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 08.03.2020.
//

import Foundation
import Firebase

protocol ChatViewModelProtocol: ViewModelProtocol {
    func getChatModel() -> ChatModel
    func firestoreQuery() -> Query
    func messageList() -> [MessageModel]
    func sendMessage(
        messageText: String,
        completion: @escaping (Bool) -> Void
    )
}

class ChatViewModel: ChatViewModelProtocol {
    let router: RouterProtocol
    let firestoreService: FirestoreService = FirestoreService()
    
    let chatModel: ChatModel
    
    var data: [MessageModel] = []
    
    init(
        router: RouterProtocol,
        chatModel: ChatModel
    ) {
        self.router = router
        self.chatModel = chatModel
    }
    
    func getChatModel() -> ChatModel {
        return self.chatModel
    }
    
    func messageList() -> [MessageModel] {
        return data
    }
    
    func firestoreQuery() -> Query {
        return firestoreService.createChatQuery(chatModel)
    }
    
    func sendMessage(
        messageText: String,
        completion: @escaping (Bool) -> Void
    ) {
        firestoreService.sendMessage(
            chatDocumentId: chatModel.documentId,
            messageText: messageText,
            completion: completion
        )
    }
}
