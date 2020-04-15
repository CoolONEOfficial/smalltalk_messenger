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
typealias FireTimestamp = Timestamp

protocol FirestoreServiceProtocol: AutoMockable {
    func chatBaseQuery(_ chatId: String) -> FireQuery
    func sendMessage(
        chatId: String,
        messageKind: [MessageModel.MessageKind],
        completion: @escaping (Bool) -> Void
    )
    func deleteMessage(
        chatId: String,
        messageDocumentId: String,
        completion: @escaping (Bool) -> Void
    )
    func leaveChat(
        chatId: String,
        completion: @escaping (Bool) -> Void
    )
    func listChatMedia(
        chatId: String,
        completion: @escaping ([MediaModel]?) -> Void
    )
    func createUser(
        _ userModel: UserModel,
        completion: @escaping (Bool) -> Void
    ) -> String
    func currentUserData(
        completion: @escaping (UserModel?) -> Void
    )
    func userData(
        _ userId: String,
        completion: @escaping (UserModel?) -> Void
    )
    func userListData(
        _ userList: [String],
        completion: @escaping ([UserModel]?) -> Void
    )
    func chatData(
        _ chatId: String,
        completion: @escaping (ChatModel?) -> Void
    )
    func onlineCurrentUser()
    func offlineCurrentUser()
    func startTypingCurrentUser(_ chatId: String)
    func endTypingCurrentUser()
    
    var contactListQuery: Query { get }
    var chatListQuery: Query { get }
}

extension FirestoreServiceProtocol {
    func sendMessage(
        chatId: String,
        messageKind: [MessageModel.MessageKind],
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        return sendMessage(
            chatId: chatId,
            messageKind: messageKind,
            completion: completion
        )
    }
    
    func deleteMessage(
        chatId: String,
        messageDocumentId: String,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        deleteMessage(
            chatId: chatId,
            messageDocumentId: messageDocumentId,
            completion: completion
        )
    }
    
    func leaveChat(
        chatId: String,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        leaveChat(
            chatId: chatId,
            completion: completion
        )
    }
}

class FirestoreService: FirestoreServiceProtocol {
    
    lazy var db: Firestore = Firestore.firestore()
    
    lazy var chatListQuery: Query = {
        return db.collection("chats")
            .whereField("users", arrayContains: Auth.auth().currentUser!.uid)
            .order(by: "lastMessage.timestamp", descending: true)
    }()
    
    lazy var contactListQuery: Query = {
        return db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .collection("contacts")
            .order(by: "localName")
    }()
    
    func chatBaseQuery(_ chatId: String) -> FireQuery {
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
    }
    
    func sendMessage(
        chatId: String,
        messageKind: [MessageModel.MessageKind],
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        do {
            let messageModel = MessageModel(
                kind: messageKind,
                userId: Auth.auth().currentUser!.uid,
                timestamp: Timestamp()
            )
            
            var messageData = try FirestoreEncoder().encode(messageModel)
            
            db.collection("chats")
                .document(chatId)
                .collection("messages")
                .addDocument(data: messageData) { err in
                    completion(err == nil)
            }
        } catch let error {
            debugPrint("error! \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func deleteMessage(
        chatId: String,
        messageDocumentId: String,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        db.collection("chats")
            .document(chatId).collection("messages")
            .document(messageDocumentId).delete { err in
                completion(err == nil)
        }
    }
    
    func leaveChat(
        chatId: String,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        db.collection("chats")
            .document(chatId).updateData([
                "users": FieldValue.arrayRemove([ Auth.auth().currentUser!.uid ])
            ]) { err in
                completion(err == nil)
        }
    }
    
    func listChatMedia(
        chatId: String,
        completion: @escaping ([MediaModel]?) -> Void
    ) {
        db.collection("chats")
            .document(chatId)
            .collection("media")
            .order(by: "timestamp")
            .getDocuments { snapshot, err in
                guard err == nil else {
                    debugPrint("Error while get chat media: \(err!.localizedDescription)")
                    completion(nil)
                    return
                }
                
                completion(snapshot?.documents.map { MediaModel.fromSnapshot($0)! })
        }
    }
    
    func createUser(
        _ userModel: UserModel,
        completion: @escaping (Bool) -> Void
    ) -> String {
        let newDoc = db.collection("users").document()
        do {
            let userData = try FirestoreEncoder().encode(userModel)
            
            newDoc.setData(userData) { err in
                    completion(err == nil)
            }
        } catch {
            debugPrint("Error: \(error)")
            completion(false)
        }
        return newDoc.documentID
    }
    
    func currentUserData(
        completion: @escaping (UserModel?) -> Void
    ) {
        return userData(Auth.auth().currentUser!.uid, completion: completion)
    }
    
    func userData(
        _ userId: String,
        completion: @escaping (UserModel?) -> Void
    ) {
        db.collection("users").document(userId)
            .addSnapshotListener { snapshot, err in
                guard err == nil else {
                    debugPrint("Error while get user data: \(err!.localizedDescription)")
                    completion(nil)
                    return
                }
                
                completion(UserModel.fromSnapshot(snapshot!))
        }
    }
    
    func userListData(
        _ userList: [String],
        completion: @escaping ([UserModel]?) -> Void
    ) {
        db.collection("users").whereField(.documentID(), in: userList)
            .addSnapshotListener { snapshot, err in
                guard err == nil else {
                    debugPrint("Error while get user list: \(err!.localizedDescription)")
                    completion(nil)
                    return
                }
                
                completion(snapshot?.documents.map { UserModel.fromSnapshot($0)! })
        }
    }
    
    func chatData(_ chatId: String, completion: @escaping (ChatModel?) -> Void) {
        db.collection("chats")
            .document(chatId).getDocument { snapshot, err in
                guard err == nil else {
                    debugPrint("Error while get chat data: \(err!.localizedDescription)")
                    completion(nil)
                    return
                }
                
                completion(ChatModel.fromSnapshot(snapshot!))
        }
    }
    
    func onlineCurrentUser() {
        updateOnlineStatus(true)
    }
    
    func offlineCurrentUser() {
        updateOnlineStatus(false)
    }
    
    private func updateOnlineStatus(_ online: Bool) {
        db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .updateData([
                "online": online
            ])
    }
    
    func startTypingCurrentUser(_ chatId: String) {
        updateTypingStatus(chatId)
    }
    
    func endTypingCurrentUser() {
        updateTypingStatus(FieldValue.delete())
    }
    
    private func updateTypingStatus(_ typing: Any) {
        db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .updateData([
                "typing": typing
            ])
    }
    
    lazy var usersListQuery: Query = {
        return db.collection("users").order(by: "name")
    }()
}
