//
//  MessageModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

struct MessageModel: Codable {
    
    let documentId: String
    let text: String
    let userId: Int
    let timestamp: Timestamp
    
    static func empty() -> MessageModel {
        return MessageModel(documentId: "", text: "", userId: 0, timestamp: Timestamp.init())
    }
    
    static func fromSnapshot(_ snapshot: DocumentSnapshot) -> MessageModel? {
        var data = snapshot.data() ?? [:]
        data["documentId"] = snapshot.documentID
        
        do {
            return try FirestoreDecoder()
                .decode(
                    MessageModel.self,
                    from: data
            )
        } catch let err {
            debugPrint("error while parse message model: \(err)")
            return nil
        }
    }
}

extension MessageModel: TextMessageProtocol {
    var date: Date {
        return timestamp.dateValue()
    }
    
    var isIncoming: Bool {
        return userId != 0 // TODO: auth user id
    }
}
