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
            .order(by: "lastMessage.timestamp", descending: true)
    }()
    
    func createChatQuery(_ chatModel: ChatModel) -> Query {
        return db.collection("chats")
            .document(chatModel.documentId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
    }
    
    func sendMessage(
        chatDocumentId: String,
        messageText: String,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        do {
            let messageModel = MessageModel(
                documentId: "",
                text: messageText,
                userId: 0, // TODO: user id
                timestamp: Timestamp()
            )
            
            var messageData = try FirestoreEncoder().encode(messageModel)
            
            db.collection("chats")
                .document(chatDocumentId)
                .collection("messages")
                .addDocument(data: messageData)
                .addSnapshotListener { snapshot, _ in
                    completion(true)
                    
                    messageData["documentId"] = snapshot?.documentID
                    
                    self.db.collection("chats")
                        .document(chatDocumentId).updateData([
                            "lastMessage": messageData
                        ])
                    
            }
        } catch let error {
            debugPrint("error! \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func deleteMessage(
        chatDocumentId: String,
        messageDocumentId: String,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        db.collection("chats")
            .document(chatDocumentId).collection("messages")
            .document(messageDocumentId).delete { err in
            completion(err == nil)
        }
    }
}
