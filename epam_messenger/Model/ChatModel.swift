//
//  ChatModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

struct ChatModel: AutoCodable {
    
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
    
    static func empty() -> ChatModel {
        return ChatModel(users: [], lastMessage: MessageModel.empty(), type: .personalCorr)
    }
    
    static func fromSnapshot(_ snapshot: DocumentSnapshot) -> ChatModel? {
        var data = snapshot.data() ?? [:]
        data["documentId"] = snapshot.documentID
        
        do {
            let d = try FirestoreDecoder()
                .decode(
                    ChatModel.self,
                    from: data
            )
            return d
        } catch let err {
            debugPrint("error while parse chat model: \(err)")
            return nil
        }
    }
}

extension ChatModel: Equatable {
    public static func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
        lhs.documentId == rhs.documentId
            && lhs.lastMessage == rhs.lastMessage
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
    
}
