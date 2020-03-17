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
        _ messageModel: MessageProtocol,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        return deleteMessage(messageModel, completion: completion)
    }
}

class ChatViewModel: ChatViewModelProtocol {
    let router: RouterProtocol
    let firestoreService: FirestoreService = FirestoreService()
    
    let chatModel: ChatModel
    
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
