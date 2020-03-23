//
//  MessageModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

typealias ImageSize = CGSize

struct MessageModel: AutoCodable {
    
    var documentId: String?
    let kind: [MessageKind]
    let userId: Int
    let timestamp: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case documentId
        case kind
        case userId
        case timestamp
        case filename
        case enumCaseKey
    }
    
    enum MessageKind: AutoCodable {
        case text(_: String)
        case image(path: String, size: ImageSize)
    }
    
    static let defaultDocumentId: String? = nil
    static let defaultKind: [MessageKind] = []
    
    static func empty() -> MessageModel {
        return MessageModel(kind: [], userId: 0, timestamp: Timestamp.init())
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
    
    static func decodeTimestamp(from container: KeyedDecodingContainer<CodingKeys>) -> Timestamp {
        if let dict = try? container.decode([String: Int64].self, forKey: .timestamp) {
            return Timestamp.init(
                seconds: dict["_seconds"]!,
                nanoseconds: Int32(exactly: dict["_nanoseconds"]!)!
            )
        }
        
        return try! container.decode(Timestamp.self, forKey: .timestamp)
    }
    
    static func checkMerge(
        left: MessageProtocol,
        right: MessageProtocol
    ) -> Bool {
        return left.userId == right.userId
            && abs(left.date.timeIntervalSince(right.date)) < 60 * 5 // 5 minutes interval
    }
}

extension MessageModel: MessageProtocol {
    var date: Date {
        return timestamp.dateValue()
    }
    
    var isIncoming: Bool {
        return userId != 0 // TODO: auth user id
    }
}

extension MessageModel: MessageTextProtocol {
    var text: String? {
        for kind in kind {
            switch kind {
            case .text(let text):
                return text
            default: break
            }
        }
        return nil
    }
}

extension MessageModel: MessageImageProtocol {
    var image: (path: String, size: ImageSize)? {
        for kind in kind {
            switch kind {
            case .image(let path, let size):
                return (path: path, size: size)
            default: break
            }
        }
        return nil
    }
}
