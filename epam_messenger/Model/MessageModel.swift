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
    
    var documentId: String = ""
    let text: String
    let userId: Int
    let timestamp: Timestamp
    
    static func empty() -> MessageModel {
        return MessageModel(text: "", userId: 0, timestamp: Timestamp.init())
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
    
    static func checkMerge(
        left: MessageProtocol,
        right: MessageProtocol
    ) -> Bool {
        return left.userId == right.userId
            && abs(left.date.timeIntervalSince(right.date)) < 60 * 5 // 5 minutes interval
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
