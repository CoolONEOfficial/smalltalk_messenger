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
            .whereField("users", arrayContains: 0)
            .order(by: "lastMessage.timestamp", descending: true)
        return db.collection("chats")
            .whereField("users", arrayContains: 0) // TODO: auth user id
    }()
    
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
                var lastMessage = try FirestoreEncoder().encode(messageModel)
                let lastMessageTimestamp = lastMessage["timestamp"] as! [String: Any]
                lastMessage["timestamp"] = Timestamp.init(
                    seconds: lastMessageTimestamp["seconds"] as! Int64,
                    nanoseconds: lastMessageTimestamp["nanoseconds"] as! Int32
                )
                
                db.collection("chats")
                    .document(chatDocumentId).updateData([
                        "lastMessage": lastMessage
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
