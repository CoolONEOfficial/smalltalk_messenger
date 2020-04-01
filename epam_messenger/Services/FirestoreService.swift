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

typealias FireQuery = Query

protocol FirestoreServiceProtocol: AutoMockable {
    func createChatQuery(_ chatModel: ChatModel) -> Query
    func sendMessage(
        chatDocumentId: String,
        messageKind: [MessageModel.MessageKind],
        completion: @escaping (Bool) -> Void
    )
    func deleteMessage(
        chatDocumentId: String,
        messageDocumentId: String,
        completion: @escaping (Bool) -> Void
    )
    func deleteChat(
        chatDocumentId: String,
        completion: @escaping (Bool) -> Void
    )
    func listChatMedia(
        chatDocumentId: String,
        completion: @escaping ([MediaModel]?) -> Void
    )
}

extension FirestoreServiceProtocol {
    func sendMessage(
        chatDocumentId: String,
        messageKind: [MessageModel.MessageKind],
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        return sendMessage(
            chatDocumentId: chatDocumentId,
            messageKind: messageKind,
            completion: completion
        )
    }
    
    func deleteMessage(
        chatDocumentId: String,
        messageDocumentId: String,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        deleteMessage(
            chatDocumentId: chatDocumentId,
            messageDocumentId: messageDocumentId,
            completion: completion
        )
    }
    
    func deleteChat(
        chatDocumentId: String,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        deleteChat(
            chatDocumentId: chatDocumentId,
            completion: completion
        )
    }
}

class FirestoreService: FirestoreServiceProtocol {
    
    lazy var db: Firestore = Firestore.firestore()
    
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
        messageKind: [MessageModel.MessageKind],
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        do {
            let messageModel = MessageModel(
                kind: messageKind, // TODO: kinds
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
    
    func deleteChat(
        chatDocumentId: String,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        db.collection("chats")
            .document(chatDocumentId).delete { err in
            completion(err == nil)
        }
    }
    
    func listChatMedia(
        chatDocumentId: String,
        completion: @escaping ([MediaModel]?) -> Void
    ) {
        db.collection("chats")
            .document(chatDocumentId).collection("media")
            .order(by: "timestamp").getDocuments { snapshot, err in
                guard err == nil else {
                    debugPrint("Error while get chat media: \(err!.localizedDescription)")
                    completion(nil)
                    return
                }
                
                completion(snapshot?.documents.map { MediaModel.fromSnapshot($0)! })
        }
    }
    
    lazy var contactsListQuery: Query = {
        return db.collection("users").order(by: "name")
    }()
    
    lazy var userContactsListQuery: Query = {
        var documentId = "JfgyNfOJh8LlnIXKKFVd"
        return db.collection("users").document("\(documentId)").collection("contacts")
    }() // for contacts
}
