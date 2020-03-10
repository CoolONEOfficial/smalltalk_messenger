//
//  ChatModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import Foundation
import Firebase
import Ballcap
import IGListKit

class ChatModel: Codable, Modelable {
    required init() {}
    
    init(
        documentId: String,
        users: [Int]?,
        name: String?,
        lastMessage: MessageModel? = nil
    ) {
        self.documentId = documentId
        self.users = users
        self.name = name
        self.lastMessage = lastMessage
    }
    
    var documentId: String?
    var users: [Int]?
    var name: String?
    var lastMessage: MessageModel?
}

extension ChatModel: Equatable {
    static public func == (rhs: ChatModel, lhs: ChatModel) -> Bool {
        return rhs.documentId == lhs.documentId
    }
}

extension ChatModel: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return NSString(string: documentId ?? "")
    }

    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ChatModel else {
            return false
        }
        
        return self.documentId == object.documentId
            && self.name == object.name
            && self.lastMessage?.isEqual(toDiffableObject: object.lastMessage) ?? true
    }
}
