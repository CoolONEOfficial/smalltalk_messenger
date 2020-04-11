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
        return users.first(where: { Auth.auth().currentUser!.uid != $0 })
    }
    
    var avatarRef: StorageReference {
        let path: String?
        
        switch type {
        case .personalCorr:
            if let friendId = friendId {
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
    
    func loadInfo(completion: @escaping (String, String) -> Void) {
        let firestoreService = FirestoreService()
        
        switch type {
        case .personalCorr:
            firestoreService.userData(friendId!) { user in
                if let user = user {
                    let title = user.fullName
                    completion(title, user.typing == self.documentId!
                        ? "\(user.name) typing..."
                        : user.onlineText
                    )
                }
            }
        case .chat(let title, _):
            completion(title, "\(users.count) users")
            
            firestoreService.userListData(users) { userList in
                if let userList = userList {
                    let typingUsers = userList.filter({
                        $0.typing == self.documentId
                            && $0.documentId != Auth.auth().currentUser!.uid
                    })
                    if typingUsers.isEmpty {
                        let onlineUsers = userList.filter({ $0.online })
                        var subtitleStr = "\(self.users.count) users"
                        if onlineUsers.count > 1 {
                            subtitleStr += ", \(onlineUsers.count) online"
                        }
                        
                        completion(title, subtitleStr)
                    } else {
                        
                        completion(title, typingUsers
                            .map({ $0.name })
                            .joined(separator: ", ") + " typing..."
                        )
                    }
                }
            }
        }
    }
    
}
