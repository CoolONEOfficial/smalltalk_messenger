//
//  FirestoreService.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 09.03.2020.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirestoreService {
    
    lazy var db: Firestore = {
        return Firestore.firestore()
    }()
    
    lazy var chatListQuery: Query = {
        return db.collection("chats").whereField("users", arrayContains: 0)
    }()
    
    func loadChatList(
        chatListListener: @escaping ([ChatModel]) -> Void,
        lastMessageListener: @escaping (MessageModel, Int) -> Void
    ) {
        chatListQuery.addSnapshotListener { querySnapshot, error in
            guard let query = querySnapshot else {
                debugPrint("Error fetching query: \(error!)")
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
                            let messageModel = MessageModel(
                                documentId: message.documentID,
                                text: message.data()["text"] as? String,
                                userId: message.data()["userId"] as? Int
                            )
                            
                            lastMessageListener(messageModel, index)
                        }
                }
            }
        }
    }
    
    
}
