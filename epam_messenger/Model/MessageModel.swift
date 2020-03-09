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

class MessageModel: Codable, Modelable {
    required init() {}
    
    init(
        documentId: String,
        text: String?,
        userId: Int?
    ) {
        self.documentId = documentId
        self.text = text
        self.userId = userId
    }
    
    var documentId: String?
    var text: String?
    var userId: Int?
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
