//
//  UserModel.swift
//  epam_messenger
//
//  Created by Maxim on 13.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

public struct UserModel: AutoCodable, AutoEquatable {
    
    var documentId: String?
    var name: String
    var surname: String
    var phoneNumber: String
    var hexColor: String?
    var avatarPath: String?
    let online: Bool
    let onlineTimestamp: FireTimestamp?
    let typing: String?
    let deleted: Bool
    
    static func decodeOnlineTimestamp(from container: KeyedDecodingContainer<CodingKeys>) -> FireTimestamp? {
        FireTimestamp.decodeTimestamp(from: container, forKey: CodingKeys.onlineTimestamp)
    }
    
    static let defaultDeleted: Bool = false
    static let defaultOnline: Bool = false
    
    static func empty() -> UserModel {
        .init(documentId: nil, name: "", surname: "",
              phoneNumber: Auth.auth().currentUser!.phoneNumber!,
              avatarPath: nil, online: true, onlineTimestamp: .init(), typing: nil, deleted: false)
    }
    
    static func deleted(_ documentId: String? = nil) -> UserModel {
        .init(documentId: documentId, name: "DELETED", surname: "", phoneNumber: "",
              hexColor: "#7d7d7d", avatarPath: nil, online: false,
              onlineTimestamp: .init(), typing: nil, deleted: true)
    }
    
    static func saved() -> UserModel {
        .init(documentId: Auth.auth().currentUser!.uid, name: "Saved messages",
              surname: "", phoneNumber: Auth.auth().currentUser!.phoneNumber!,
              hexColor: nil, avatarPath: nil, online: true, onlineTimestamp: .init(), typing: nil, deleted: false)
    }
    
    static func fromSnapshot(_ snapshot: DocumentSnapshot) -> UserModel? {
        var data = snapshot.data() ?? [:]
        data["documentId"] = snapshot.documentID
        
        do {
            return try FirestoreDecoder()
                .decode(
                    UserModel.self,
                    from: data
            )
        } catch let err {
            debugPrint("error while parse test model: \(err)")
            return nil
        }
    }
    
}

// MARK: Formatter for online text

var onlineTextFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.dateTimeStyle = .named
    return formatter
}()

extension UserModel: UserProtocol {
    
    var color: UIColor {
        get {
            UIColor(hexString: hexColor) ?? .accent
        }
        set {
            hexColor = newValue.hexString
        }
    }
    
    var fullName: String {
        return "\(name) \(surname)"
    }
    
    var placeholderName: String {
        return "\(name.first ?? " ")\(surname.first ?? " ")"
    }
    
    var onlineText: String {
        online
            ? "Online"
            : "last seen \(onlineTimestamp != nil ? onlineTextFormatter.string(for: onlineTimestamp!.dateValue())! : "recently")"
    }
    
    var avatarRef: StorageReference? {
        avatarPath != nil ? Storage.storage().reference(withPath: avatarPath!) : nil
    }
    
}
