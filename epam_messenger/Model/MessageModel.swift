//
//  MessageModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import Foundation
import Firebase
import MessageKit

struct MessageModel: Codable {
    
    let documentId: String?
    let text: String
    let userId: Int
    let timestamp: Timestamp
    
    static func empty() -> MessageModel {
        return MessageModel(documentId: "", text: "", userId: 0, timestamp: Timestamp.init())
    }
}

extension MessageModel: MessageType {
    var sender: SenderType {
        return Sender(senderId: String(userId), displayName: "123")
    }
    
    var messageId: String {
        return documentId!
    }
    
    var sentDate: Date {
        return timestamp.dateValue()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
    
}
