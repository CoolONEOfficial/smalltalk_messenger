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
import FirebaseFunctions

typealias FireQuery = Query
typealias FireTimestamp = Timestamp

protocol FirestoreServiceProtocol: AutoMockable {
    func sendMessage(
        chatId: String,
        messageKind: [MessageModel.MessageKind],
        completion: @escaping (Error?) -> Void
    )
    func deleteMessage(
        chatId: String,
        messageDocumentId: String,
        completion: @escaping (Error?) -> Void
    )
    func deleteChat(
        chat: ChatProtocol,
        completion: @escaping (Error?) -> Void
    )
    func updateChat(
        _ chatModel: ChatModel,
        completion: @escaping (Error?) -> Void
    )
    func kickChatUser(
        chatId: String,
        userId: String,
        completion: @escaping (Error?) -> Void
    )
    func inviteChatUser(
        chatId: String,
        userId: String,
        completion: @escaping (Error?) -> Void
    )
    func listChatMedia(
        chatId: String,
        completion: @escaping ([MediaModel]?) -> Void
    )
    func getChatData(
        _ chatId: String,
        completion: @escaping (ChatModel?) -> Void
    )
    func listenChatData(
        _ chatId: String,
        completion: @escaping (ChatModel?) -> Void
    )
    func getChatData(
        userId: String,
        completion: @escaping (ChatModel?) -> Void
    )
    @discardableResult func createChat(
        _ chatModel: ChatModel,
        completion: @escaping (Error?) -> Void
    ) -> String
    func createContact(
        _ contactModel: ContactModel,
        completion: @escaping (Error?) -> Void
    )
    func createUser(
        _ userModel: UserModel,
        completion: @escaping (Error?) -> Void
    ) -> String
    func listenCurrentUserData(
        completion: @escaping (UserModel?) -> Void
    )
    func listenUserData(
        _ userId: String,
        completion: @escaping (UserModel?) -> Void
    )
    func getUserData(
        _ userId: String,
        completion: @escaping (UserModel?) -> Void
    )
    func listenUserListData(
        _ userList: [String],
        completion: @escaping ([UserModel]?) -> Void
    )
    func searchUsers(
        by phoneNumbers: [String],
        completion: @escaping ([UserModel]?, Bool) -> Void
    )
    func onlineCurrentUser()
    func offlineCurrentUser()
    func startTypingCurrentUser(_ chatId: String)
    func endTypingCurrentUser()
    
    var contactListQuery: Query { get }
    var chatListQuery: Query { get }
    func chatBaseQuery(_ chatId: String) -> FireQuery
}

extension FirestoreServiceProtocol {
    
    func sendMessage(
        chatId: String,
        messageKind: [MessageModel.MessageKind],
        completion: @escaping (Error?) -> Void = {_ in}
    ) {
        return sendMessage(
            chatId: chatId,
            messageKind: messageKind,
            completion: completion
        )
    }
    
    func kickChatUser(
        chatId: String,
        userId: String,
        completion: @escaping (Error?) -> Void = {_ in}
    ) {
        kickChatUser(chatId: chatId, userId: userId, completion: completion)
    }
    
    func inviteChatUser(
        chatId: String,
        userId: String,
        completion: @escaping (Error?) -> Void = {_ in}
    ) {
        inviteChatUser(chatId: chatId, userId: userId, completion: completion)
    }
    
    func deleteMessage(
        chatId: String,
        messageDocumentId: String,
        completion: @escaping (Error?) -> Void = {_ in}
    ) {
        deleteMessage(
            chatId: chatId,
            messageDocumentId: messageDocumentId,
            completion: completion
        )
    }
    
    func deleteChat(
        chat: ChatProtocol,
        completion: @escaping (Error?) -> Void = {_ in}
    ) {
        deleteChat(
            chat: chat,
            completion: completion
        )
    }
}

class FirestoreService: FirestoreServiceProtocol {
    
    lazy var db: Firestore = Firestore.firestore()
    
    // MARK: - Message
    
    func chatBaseQuery(_ chatId: String) -> FireQuery {
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
    }
    
    func sendMessage(
        chatId: String,
        messageKind: [MessageModel.MessageKind],
        completion: @escaping (Error?) -> Void = {_ in}
    ) {
        do {
            let messageModel = MessageModel(
                kind: messageKind,
                userId: Auth.auth().currentUser!.uid,
                timestamp: Timestamp()
            )
            
            let messageData = try FirestoreEncoder().encode(messageModel)
            
            db.collection("chats")
                .document(chatId)
                .collection("messages")
                .addDocument(data: messageData) { err in
                    completion(err)
            }
        } catch let error {
            debugPrint("error! \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    func deleteMessage(
        chatId: String,
        messageDocumentId: String,
        completion: @escaping (Error?) -> Void = {_ in}
    ) {
        db.collection("chats")
            .document(chatId).collection("messages")
            .document(messageDocumentId).delete { err in
                completion(err)
        }
    }
    
    // MARK: - Chat
    
    lazy var chatListQuery: Query = {
        return db.collection("chats")
            .whereField("users", arrayContains: Auth.auth().currentUser!.uid)
            .order(by: "lastMessage.timestamp", descending: true)
    }()
    
    @discardableResult
    func createChat(
        _ chatModel: ChatModel,
        completion: @escaping (Error?) -> Void
    ) -> String {
        let newDoc = db.collection("chats").document()
        do {
            let chatData = try FirestoreEncoder().encode(chatModel)
            
            newDoc.setData(chatData) { err in
                completion(err)
            }
        } catch {
            debugPrint("Error: \(error)")
            completion(error)
        }
        return newDoc.documentID
    }
    
    func updateChat(
        _ chatModel: ChatModel,
        completion: @escaping (Error?) -> Void
    ) {
        db.collection("chats")
            .document(chatModel.documentId!)
            .updateData(
                try! FirestoreEncoder().encode(chatModel),
                completion: completion
        )
    }
    
    private func clearSavedMessages(
        chatId: String,
        completion: @escaping (Error?) -> Void = {_ in}
    ) {
        Functions.functions().httpsCallable("clearSavedMessages")
            .call([ "chatId": chatId ]) { _, error in
                completion(error)
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
            .addSnapshotListener { snapshot, err in
                guard err == nil else {
                    debugPrint("Error while get chat media: \(err!.localizedDescription)")
                    completion(nil)
                    return
                }
                
                completion(snapshot?.documents.map { MediaModel.fromSnapshot($0)! })
        }
    }
    
    func deleteChat(
        chat: ChatProtocol,
        completion: @escaping (Error?) -> Void = {_ in}
    ) {
        guard let chatId = chat.documentId else { return }
        
        switch chat.type {
        case .personalCorr:
            if chat.users.count > 1 {
                leaveChat(chatId: chatId, completion: completion)
            } else {
                deleteChat(chatId: chatId, completion: completion)
            }
        case .chat(_, let adminId, _, _):
            if Auth.auth().currentUser?.uid == adminId {
                deleteChat(chatId: chatId, completion: completion)
            } else {
                leaveChat(chatId: chatId, completion: completion)
            }
        case .savedMessages:
            clearSavedMessages(chatId: chatId, completion: completion)
        }
    }
    
    private func deleteChat(chatId: String, completion: @escaping (Error?) -> Void) {
        Functions.functions().httpsCallable("deleteChat")
            .call([ "chatId": chatId ]) { _, error in
                completion(error)
        }
    }
    
    private func leaveChat(chatId: String, completion: @escaping (Error?) -> Void) {
        db.collection("chats")
            .document(chatId).updateData([
                "users": FieldValue.arrayRemove([ Auth.auth().currentUser!.uid ])
            ]) { err in
                completion(err)
        }
    }
    
    func getChatData(_ chatId: String, completion: @escaping (ChatModel?) -> Void) {
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
    
    func listenChatData(
        _ chatId: String,
        completion: @escaping (ChatModel?) -> Void
    ) {
        db.collection("chats")
            .document(chatId).addSnapshotListener { snapshot, err in
                guard err == nil else {
                    debugPrint("Error while listen chat data: \(err!.localizedDescription)")
                    completion(nil)
                    return
                }
                
                completion(ChatModel.fromSnapshot(snapshot!))
        }
    }
    
    func getChatData(userId: String, completion: @escaping (ChatModel?) -> Void) {
        let currentId = Auth.auth().currentUser!.uid
        db.collection("chats")
            .whereField("type.personalCorr.between", in: [[currentId, userId], [userId, currentId]])
            .limit(to: 1)
            .getDocuments { snapshot, err in
                guard err == nil else {
                    debugPrint("Error while get chat data: \(err!.localizedDescription)")
                    completion(nil)
                    return
                }
                
                completion(!(snapshot?.documents.isEmpty ?? true)
                    ? ChatModel.fromSnapshot(snapshot!.documents.first!)
                    : nil
                )
        }
    }
    
    // MARK: - User
    
    lazy var usersListQuery: Query = {
        return db.collection("users").order(by: "name")
    }()
    
    func kickChatUser(chatId: String, userId: String, completion: @escaping (Error?) -> Void = {_ in}) {
        db.collection("chats")
            .document(chatId)
            .updateData(
                [
                    "users": FieldValue.arrayRemove([ userId ])
                ],
                completion: completion
        )
    }
    
    func inviteChatUser(chatId: String, userId: String, completion: @escaping (Error?) -> Void = {_ in}) {
        db.collection("chats")
            .document(chatId)
            .updateData(
                [
                    "users": FieldValue.arrayUnion([ userId ])
                ],
                completion: completion
        )
    }
    
    func listenCurrentUserData(
        completion: @escaping (UserModel?) -> Void
    ) {
        return listenUserData(Auth.auth().currentUser!.uid, completion: completion)
    }
    
    func getUserData(_ userId: String, completion: @escaping (UserModel?) -> Void) {
        db.collection("users").document(userId)
            .getDocument { snapshot, err in
                guard err == nil else {
                    debugPrint("Error while get user data: \(err!.localizedDescription)")
                    completion(nil)
                    return
                }
                
                completion(UserModel.fromSnapshot(snapshot!))
        }
    }
    
    func createUser(
        _ userModel: UserModel,
        completion: @escaping (Error?) -> Void
    ) -> String {
        let newDoc = db.collection("users").document(Auth.auth().currentUser!.uid)
        do {
            let userData = try FirestoreEncoder().encode(userModel)
            
            newDoc.setData(userData) { err in
                completion(err)
            }
        } catch {
            debugPrint("Error: \(error)")
            completion(error)
        }
        return newDoc.documentID
    }
    
    func listenUserData(
        _ userId: String,
        completion: @escaping (UserModel?) -> Void
    ) {
        db.collection("users").document(userId)
            .addSnapshotListener { snapshot, err in
                guard err == nil else {
                    debugPrint("Error while listen user data: \(err!.localizedDescription)")
                    completion(nil)
                    return
                }
                
                completion(UserModel.fromSnapshot(snapshot!))
        }
    }
    
    @Atomic var loadedCount = 0
    
    func searchUsers(
        by phoneNumbers: [String],
        completion: @escaping ([UserModel]?, Bool) -> Void
    ) {
        let chunked = phoneNumbers.chunked(into: 10)
        loadedCount = 0
        
        for chunk in chunked {
            db.collection("users")
                .whereField("phoneNumber", in: chunk)
                .getDocuments { snapshot, err in
                    self.loadedCount += 1
                    let last = self.loadedCount == chunked.count - 1
                    guard err == nil else {
                        debugPrint("Error while get contacts data: \(err!.localizedDescription)")
                        completion(nil, last)
                        return
                    }
                    
                    completion(
                        snapshot?.documents.map { UserModel.fromSnapshot($0)! },
                        last
                    )
            }
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
    
    // MARK: - Contact
    
    lazy var contactListQuery: Query = {
        return db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .collection("contacts")
            .order(by: "localName")
    }()
    
    func createContact(
        _ contactModel: ContactModel,
        completion: @escaping (Error?) -> Void
    ) {
        do {
            let contactData = try FirestoreEncoder().encode(contactModel)
            
            db.collection("users")
                .document(Auth.auth().currentUser!.uid)
                .collection("contacts")
                .addDocument(data: contactData) { err in
                    completion(err)
            }
        } catch {
            debugPrint("Error: \(error)")
            completion(error)
        }
    }
    
    func listenUserListData(
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

}

// MARK: Contacts creation helper

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
