//
//  MessageModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import Foundation
import Firebase

struct MessageModel: AutoCodable {
    
    var documentId: String
    let text: String
    let userId: Int
    let timestamp: Timestamp
    
    enum SkipEncodingKeys {
        case documentId
    }
    
    static func empty() -> MessageModel {
        return MessageModel(documentId: "", text: "", userId: 0, timestamp: Timestamp.init())
    }
}
