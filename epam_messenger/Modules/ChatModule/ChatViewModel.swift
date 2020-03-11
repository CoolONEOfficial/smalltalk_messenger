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
    func insertMessages(_ data: [Any])
    func sendMessage(
        messageModel: MessageModel,
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
        guard let chatDocumentId = chatModel.documentId else {
            debugPrint("chat document id not found")
            return
        }
        
        firestoreService.loadChat(
            chatDocumentId,
            messagesListener: { parsedData in
                let emptyData = self.data.isEmpty
                
                self.data = parsedData
                
                self.viewController.performUpdates(keepOffset: !emptyData)
        }
        )
    }
    
    func insertMessages(_ data: [Any]) {
        for component in data {
            //let user = Sender(senderId: "test", displayName: "Noname")
            if let str = component as? String {
                let message = MessageModel(
                    documentId: UUID().uuidString,
                    text: str,
                    userId: 0,
                    timestamp: Timestamp.init()
                )
                insertMessage(message)
            }
        }
    }
    
    func insertMessage(_ message: MessageModel) {
        data.append(message)
        viewController.didInsertMessage()
    }
    
    func sendMessage(
        messageModel: MessageModel,
        completion: @escaping (Bool) -> Void
    ) {
        guard let chatDocumentId = chatModel.documentId else {
             debugPrint("chat document id not found")
             return
         }
        
        firestoreService.sendMessage(
            chatDocumentId: chatDocumentId,
            messageModel: messageModel,
            completion: completion
        )
    }
}
