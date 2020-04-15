//
//  MessageModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 08.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

public typealias ImageSize = CGSize

public struct MessageModel: AutoCodable {
    
    var documentId: String?
    let kind: [MessageKind]
    let userId: String
    let timestamp: Timestamp
    
    var chatId: String?
    var chatUsers: [String]?
    
    enum CodingKeys: String, CodingKey {
        case documentId
        case kind
        case userId
        case timestamp
        case chatId
        case chatUsers
        case enumCaseKey
    }
    
    public enum MessageKind: AutoCodable, AutoEquatable {
        case text(_: String)
        case image(path: String, size: ImageSize)
        case audio(path: String)
        case forward(userId: String)
    }
    
    static let defaultKind: [MessageKind] = []
    
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
        Timestamp.decodeTimestamp(from: container, forKey: CodingKeys.timestamp)
    }
    
    static func checkMerge(
        _ left: MessageProtocol,
        _ right: MessageProtocol
    ) -> Bool {
        return left.userId == right.userId
            && abs(left.date.timeIntervalSince(right.date)) < 60 * 5 // 5 minutes interval
    }
}

extension MessageModel: Equatable {
    public static func == (lhs: MessageModel, rhs: MessageModel) -> Bool {
        lhs.documentId == rhs.documentId
            && lhs.kind == rhs.kind
    }
}

extension MessageModel: MessageProtocol {
    var date: Date {
        return timestamp.dateValue()
    }
    
    public var isIncoming: Bool {
        return userId != Auth.auth().currentUser!.uid
    }
    
    var textColor: UIColor {
        return isIncoming
            ? .plainText
            : .accentText
    }
    
    var backgroundColor: UIColor {
        return isIncoming
            ? .plainBackground
            : .accent
    }
    
    func forwardedKind() -> [MessageModel.MessageKind] {
        var forwardedKind = kind
        if case .forward = forwardedKind.first {
            forwardedKind.remove(at: 0)
        }
        forwardedKind.insert(.forward(userId: userId), at: 0)
        return forwardedKind
    }
    
    var previewText: String {
        var imageCount = 0
        var text = ""
        var attachmentText = ""
        var icon = ""
        for mKind in kind {
            switch mKind {
            case .image:
                imageCount += 1
                icon = "🖼️ "
                attachmentText = "Image"
            case .audio:
                icon = "🎵 "
                attachmentText = "Audio"
            case .text(let kindText):
                text = kindText
            case .forward: break
            }
        }
        return "\(imageCount > 1 ? "x\(imageCount) " : "")\(icon)\(text.isEmpty ? attachmentText : text)"
    }
    
    var timestampText: String {
        let calendar = Calendar.current
        let components = date.get(.day, .year)
        let now = Date()

        let formatter = DateFormatter()
        if components.day == now.get(.day).day! {
            formatter.dateFormat = "HH:mm"
        } else if calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: date),
            to: calendar.startOfDay(for: now)
        ).day! < 6 {
            formatter.dateFormat = "E"
        } else if components.year! == now.get(.year).year! {
            formatter.dateFormat = "dd.MM"
        } else {
            formatter.dateFormat = "dd.MM.yy"
        }
        
        return formatter.string(from: date)
    }
}

extension MessageModel: MessageTextProtocol {
    func kindText(at: Int) -> String? {
        switch kind[at] {
        case .text(let text):
            return text
        default:
            return nil
        }
    }
}

extension MessageModel: MessageImageProtocol {
    func kindImage(at: Int) -> (path: String, size: ImageSize)? {
        switch kind[at] {
        case .image(let path, let size):
            return (path: path, size: size)
        default:
            return nil
        }
    }
}

extension MessageModel: MessageAudioProtocol {
    func kindAudio(at: Int) -> String? {
        switch kind[at] {
        case .audio(let path):
            return path
        default:
            return nil
        }
    }
}

extension MessageModel: MessageForwardProtocol {
    func kindForwardUser(at: Int) -> String? {
        switch kind[at] {
        case .forward(let userId):
            return userId
        default:
            return nil
        }
    }
}

// MARK: - Date components helper

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
