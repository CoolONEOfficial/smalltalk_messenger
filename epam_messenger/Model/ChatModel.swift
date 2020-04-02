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
    
}
