//
//  ChatViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 08.03.2020.
//

import Foundation
import Firebase

protocol ChatViewModelProtocol: ViewModelProtocol, AutoMockable {
    func getChatModel() -> ChatModel
    func firestoreQuery() -> Query
    func sendMessage(
        _ messageText: String,
        completion: @escaping (Bool) -> Void
    )
    func deleteMessage(
        _ messageModel: MessageProtocol,
        completion: @escaping (Bool) -> Void
    )
}

extension ChatViewModelProtocol {
    func deleteMessage(
        _ messageModel: MessageProtocol,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        return deleteMessage(messageModel, completion: completion)
    }
    
    func sendMessage(
        _ messageText: String,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        return sendMessage(messageText, completion: completion)
    }
}

class ChatViewModel: ChatViewModelProtocol {
    let router: RouterProtocol
    let firestoreService: FirestoreServiceProtocol
    
    let chatModel: ChatModel
    
    init(
        router: RouterProtocol,
        chatModel: ChatModel,
        firestoreService: FirestoreServiceProtocol = FirestoreService()
    ) {
        self.router = router
        self.chatModel = chatModel
        self.firestoreService = firestoreService
    }
    
    func getChatModel() -> ChatModel {
        return self.chatModel
    }
    
    func firestoreQuery() -> Query {
        return firestoreService.createChatQuery(chatModel)
    }
    
    func sendMessage(
        _ messageText: String,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        firestoreService.sendMessage(
            chatDocumentId: chatModel.documentId,
            messageText: messageText,
            completion: completion
        )
    }
    
    func deleteMessage(
        _ messageModel: MessageProtocol,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        firestoreService.deleteMessage(
            chatDocumentId: chatModel.documentId,
            messageDocumentId: messageModel.documentId,
            completion: completion
        )
    }
}
