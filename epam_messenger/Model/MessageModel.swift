//
//  MessageModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import Foundation
import Firebase
import Ballcap
import IGListKit
import MessageKit

class MessageModel: Modelable, Codable {
    required init() {}
    
    init(
        documentId: String?,
        text: String?,
        userId: Int?,
        timestamp: Timestamp?
    ) {
        self.documentId = documentId
        self.text = text
        self.userId = userId
        self.timestamp = timestamp
    }
    
    var documentId: String?
    var text: String?
    var userId: Int?
    var timestamp: Timestamp?
    
    // MARK: Codable
    
    enum CodingKeys: String, CodingKey {
      case text
      case userId
      case timestamp
    }
    
    required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      text = try container.decode(String.self, forKey: .text)
      userId = try container.decode(Int.self, forKey: .userId)
      timestamp = try container.decode(Timestamp.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(text, forKey: .text)
      try container.encode(userId, forKey: .userId)
      try container.encode(timestamp, forKey: .timestamp)
    }
}

extension MessageModel: Equatable {
    static public func == (rhs: MessageModel, lhs: MessageModel) -> Bool {
        return rhs.documentId == lhs.documentId
    }
}

extension MessageModel: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: documentId ?? "")
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? MessageModel else {
            return false
        }
        
        return self.documentId == object.documentId
            && self.text == object.text
    }
}

extension MessageModel: MessageType {
    
    var sender: SenderType {
        return Sender(senderId: String(userId ?? 0), displayName: "TestUser")
    }
    
    var messageId: String {
        return documentId ?? ""
    }
    
    var sentDate: Date {
        return timestamp?.dateValue() ?? Date()
    }
    
    var kind: MessageKind {
        return .text(text ?? "")
    }
    
}
