//
//  ChatModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

struct ChatModel: Decodable {
    
    var documentId: String = ""
    let users: [Int]
    let name: String
    let lastMessage: MessageModel?
    
    static func empty() -> ChatModel {
        return ChatModel(users: [], name: "", lastMessage: MessageModel.empty())
    }
    
    static func fromSnapshot(_ snapshot: DocumentSnapshot) -> ChatModel? {
        var data = snapshot.data() ?? [:]
        data["documentId"] = "testdocid"
        
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
