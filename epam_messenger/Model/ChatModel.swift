//
//  ChatModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import Foundation
import Firebase

struct ChatModel: Decodable {
    
    let documentId: String
    let users: [Int]
    let name: String
    let lastMessage: MessageModel?
    
    static func empty() -> ChatModel {
        return ChatModel(documentId: "", users: [], name: "", lastMessage: MessageModel.empty())
    }
}
