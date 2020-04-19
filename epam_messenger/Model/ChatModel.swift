//
//  ChatModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

public struct ChatModel: AutoCodable, AutoEquatable {
    
    var documentId: String!
    let users: [String]
    let lastMessage: MessageModel
    let type: ChatType
    
    enum CodingKeys: String, CodingKey {
        case documentId
        case users
        case lastMessage
        case type
        case enumCaseKey
    }
    
    static func fromUserId(_ userId: String) -> ChatModel {
        .init(
            documentId: nil,
            users: Auth.auth().currentUser!.uid != userId
                ? [
                    Auth.auth().currentUser!.uid,
                    userId
                ]
                : [ userId ],
            lastMessage: .empty(),
            type: Auth.auth().currentUser!.uid != userId
                ? .personalCorr(
                    between: [
                        Auth.auth().currentUser!.uid,
                        userId
                    ]
                )
                : .savedMessages
        )
    }
    
    static let defaultDocumentId: String! = nil
    
    static func fromSnapshot(_ snapshot: DocumentSnapshot) -> ChatModel? {
        var data = snapshot.data() ?? [:]
        data["documentId"] = snapshot.documentID
        
        do {
            return try FirestoreDecoder()
                .decode(
                    ChatModel.self,
                    from: data
            )
        } catch let err {
            debugPrint("error while parse chat model: \(err)")
            return nil
        }
    }
}

extension ChatModel: ChatProtocol {
    
    var friendId: String? {
        if case .personalCorr(let between) = type {
            return between.first(where: { Auth.auth().currentUser!.uid != $0 })
        }
        return nil
    }
    
    var avatarRef: StorageReference {
        let path: String?
        
        switch type {
        case .personalCorr, .savedMessages:
            if let friendId = self.friendId ?? Auth.auth().currentUser?.uid {
                path = "users/\(friendId)/avatar.jpg"
            } else {
                path = nil
            }
        case .chat:
            if let docId = documentId {
                path = "chats/\(docId)/avatar.jpg"
            } else {
                path = nil
            }
        }
        
        return Storage.storage().reference(withPath: path!)
    }
    
    func loadInfo(completion: @escaping (
        _ title: String, _ subtitle: String, _ placeholderText: String?, _ placeholderColor: UIColor?
    ) -> Void) {
        let firestoreService = FirestoreService()
        
        switch type {
        case .personalCorr, .savedMessages:
            if let friendId = friendId {
                firestoreService.listenUserData(friendId) { user in
                    let maybeDeletedUser = user ?? .deleted(friendId)
                    let title = maybeDeletedUser.fullName
                    completion(
                        title,
                        self.documentId != nil && maybeDeletedUser.typing == self.documentId
                            ? "\(maybeDeletedUser.name) typing..."
                            : maybeDeletedUser.onlineText,
                        user?.placeholderName,
                        user?.color
                    )
                }
            } else {
                completion("Saved messages", "", "", nil)
            }
        case .chat(let title, _, let color):
            firestoreService.userListData(users) { userList in
                if let userList = userList {
                    let typingUsers = userList.filter({
                        $0.typing == self.documentId
                            && $0.documentId != Auth.auth().currentUser!.uid
                    })
                    let subtitleStr: String
                    if typingUsers.isEmpty {
                        let onlineUsers = userList.filter({ $0.online })
                        subtitleStr = "\(self.users.count) users"
                            + (onlineUsers.count > 1
                                ? ", \(onlineUsers.count) online"
                                : "")
                    } else {
                        subtitleStr = typingUsers
                            .map({ $0.name })
                            .joined(separator: ", ") + " typing..."
                    }
                    
                    completion(
                        title,
                        subtitleStr,
                        String(title.first ?? " "),
                        UIColor(hexString: color)
                    )
                }
            }
        }
    }
    
}
