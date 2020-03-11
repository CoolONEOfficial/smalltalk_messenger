//
//  FirestoreService.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 09.03.2020.
//

import Foundation
import Firebase
import FirebaseFirestore
import CodableFirebase

class FirestoreService {
    
    lazy var db: Firestore = {
        return Firestore.firestore()
    }()
    
    lazy var chatListQuery: Query = {
        return db.collection("chats")
            .whereField("users", arrayContains: 0) // TODO: auth user id
    }()
    
    func loadChatList(
        chatListListener: @escaping ([ChatModel]) -> Void,
        lastMessageListener: @escaping (MessageModel, Int) -> Void
    ) {
        chatListQuery.addSnapshotListener { querySnapshot, error in
            guard let query = querySnapshot else {
                debugPrint("Error fetching chats query: \(error!)")
                return
            }
            guard let data: [QueryDocumentSnapshot] = query.documents else {
                debugPrint("Documents data was empty.")
                return
            }
            
            let parsedData = data.map { snapshot -> ChatModel in
                return ChatModel(
                    documentId: snapshot.documentID,
                    users: snapshot.data()["users"] as? [Int],
                    name: snapshot.data()["name"] as? String
                )
            }
            
            chatListListener(parsedData)
            
            for (index, snapshot) in data.enumerated() {
                snapshot.reference.collection("messages")
                    .order(by: "timestamp", descending: true)
                    .limit(to: 1)
                    .addSnapshotListener { messagesSnapshot, error in
                        guard let messages = messagesSnapshot else {
                            debugPrint("Error fetching messages: \(error!)")
                            return
                        }
                        
                        if let message = messages.documents.first {
                            let messageData = message.data()
                            let messageModel = MessageModel(
                                documentId: message.documentID,
                                text: messageData["text"] as? String,
                                userId: messageData["userId"] as? Int,
                                timestamp: messageData["timestamp"] as? Timestamp
                            )
                            
                            lastMessageListener(messageModel, index)
                        }
                }
            }
        }
    }
    
    func loadChat(
        _ chatDocumentId: String,
        messagesListener: @escaping ([MessageModel]) -> Void
    ) {
        db.collection("chats").document(chatDocumentId).collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                guard let query = querySnapshot else {
                    debugPrint("Error fetching messages query: \(error!)")
                    return
                }
                guard let data: [QueryDocumentSnapshot] = query.documents else {
                    debugPrint("Documents data was empty.")
                    return
                }
                
                let parsedData = data.map { snapshot -> MessageModel in
                    let messageData = snapshot.data()
                    return MessageModel(
                        documentId: snapshot.documentID,
                        text: messageData["text"] as? String,
                        userId: messageData["userId"] as? Int,
                        timestamp: messageData["timestamp"] as? Timestamp
                    )
                }
                
                messagesListener(parsedData)
        }
    }
    
    func sendMessage(
        chatDocumentId: String,
        messageModel: MessageModel,
        completion: @escaping (Bool) -> Void
    ) {
        do {
            try db.collection("chats")
                .document(chatDocumentId)
                .collection("messages")
                .addDocument(from: messageModel)
                .addSnapshotListener { _, _ in
                    completion(true)
            }
            do {
                try db.collection("chats")
                    .document(chatDocumentId).updateData([
                        "lastMessage": try FirestoreEncoder().encode(messageModel)
                    ])
            } catch let err {
                debugPrint("error while encode messagemodel: \(err)")
            }
        } catch let error {
            debugPrint("error! \(error.localizedDescription)")
            completion(false)
        }
    }
}
