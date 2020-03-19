//
//  MessageModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import Foundation
import Firebase
import MessageKit

struct MessageModel: Codable, AutoDecodable {
    
    let documentId: String?
    let text: String
    let userId: Int
    let timestamp: Timestamp
    
    static func empty() -> MessageModel {
        return MessageModel(documentId: "", text: "", userId: 0, timestamp: Timestamp.init())
    }
    
    static func decodeTimestamp(from container: KeyedDecodingContainer<CodingKeys>) -> Timestamp {
        if let dict = try? container.decode([String: Int64].self, forKey: .timestamp) {
            return Timestamp.init(
                seconds: dict["_seconds"]!,
                nanoseconds: Int32(exactly: dict["_nanoseconds"]!)!
            )
        }
        
        return try! container.decode(Timestamp.self, forKey: .timestamp)
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
