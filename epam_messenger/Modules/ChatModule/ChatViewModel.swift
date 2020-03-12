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
    func messageList() -> [MessageModel]
    func sendMessage(
        messageText: String,
        completion: @escaping (Bool) -> Void
    )
}

class ChatViewModel: ChatViewModelProtocol {
    let router: RouterProtocol
    let viewController: ChatViewControllerProtocol
    let firestoreService: FirestoreService = FirestoreService()
    
    let chatModel: ChatModel
    
    var data: [MessageModel] = []
    
    init(
        router: RouterProtocol,
        chatModel: ChatModel,
        viewController: ChatViewControllerProtocol
    ) {
        self.router = router
        self.chatModel = chatModel
        self.viewController = viewController
    }
    
    func getChatModel() -> ChatModel {
        return self.chatModel
    }
    
    func messageList() -> [MessageModel] {
        return data
    }
    
    func viewDidLoad() {
        var firstLoad = true
        firestoreService.loadChat(
            chatModel.documentId,
            messagesListener: { parsedData in
                self.data = parsedData
                self.viewController.performUpdates(keepOffset: !firstLoad)
                firstLoad = false
        }
        )
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
