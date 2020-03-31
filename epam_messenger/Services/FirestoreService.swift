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
    
    func loadChat(
        _ chatDocumentId: String,
        messagesListener: @escaping ([MessageModel]) -> Void
    ) {
        db.collection("chats").document(chatDocumentId).collection("messages")
            .order(by: "timestamp", descending: true)
            .limit(to: 20)
            .addSnapshotListener { querySnapshot, error in
                guard let query = querySnapshot else {
                    debugPrint("Error fetching messages query: \(error!)")
                    return
                }
                let data = query.documents.reversed()
                
                let parsedData = data.map { snapshot -> MessageModel in
                    var messageData = snapshot.data()
                    messageData["documentId"] = snapshot.documentID
                    
                    return try! FirestoreDecoder()
                        .decode(
                            MessageModel.self,
                            from: messageData
                    )
                }
                
                messagesListener(parsedData)
        }
    }
    
    func sendMessage(
        chatDocumentId: String,
        messageText: String,
        completion: @escaping (Bool) -> Void
    ) {
        do {
            let messageModel = MessageModel(
                documentId: nil,
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
    
    lazy var contactsListQuery: Query = {
        return db.collection("users").order(by: "name")
    }()
    
    lazy var userContactsListQuery: Query = {
        var documentId = "7kEMVwxyIccl9bawojE3"
        return db.collection("users").document("\(documentId)").collection("contacts")
    }() // for contacts
    
}
