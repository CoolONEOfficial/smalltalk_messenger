//
//  ChatModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import Foundation
import Firebase

struct ChatModel: AutoCodable {
    
    var documentId: String?
    let users: [Int]
    let name: String
    var lastMessage: MessageModel?
    
    enum SkipEncodingKeys {
        case lastMessage
        case documentId
    }
    
    static func empty() -> ChatModel {
        return ChatModel(documentId: "", users: [], name: "", lastMessage: MessageModel.empty())
    }
}
