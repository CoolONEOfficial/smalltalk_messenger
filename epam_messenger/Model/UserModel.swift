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
    let online: Bool
    let typing: String?
    
    static let defaultOnline: Bool = false
    
    static func empty() -> UserModel {
        .init(documentId: nil, name: "", surname: "",
              phoneNumber: Auth.auth().currentUser!.phoneNumber!,
              online: true, typing: nil)
    }
    
    static func deleted() -> UserModel {
        .init(documentId: nil, name: "DELETED", surname: "", phoneNumber: "",
              hexColor: "#7d7d7d", online: false, typing: nil)
    }
    
    static func saved() -> UserModel {
        .init(documentId: Auth.auth().currentUser!.uid, name: "Saved messages", surname: "", phoneNumber: Auth.auth().currentUser!.phoneNumber!,
              hexColor: nil, online: true, typing: nil)
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
    
    static func convertUser(_ user: UserModel?) -> UserModel {
        if let user = user {
            if user.documentId == Auth.auth().currentUser!.uid {
                return .saved()
            } else {
                return user
            }
        } else {
            return .deleted()
        }
    }
    
    static func avatarRef(byId userId: String) -> StorageReference {
        Storage.storage().reference(withPath: "users/\(userId)/avatar.jpg")
    }
}

extension UserModel: UserProtocol {
    
    var color: UIColor? {
        get {
            UIColor(hexString: hexColor)
        }
        set {
            hexColor = newValue?.hexString
        }
    }
    
    var fullName: String {
        return "\(name) \(surname)"
    }
    
    var placeholderName: String {
        return "\(name.first ?? " ")\(surname.first ?? " ")"
    }
    
    var onlineText: String {
        return online
            ? "Online"
            : "Offline"
    }
    
    var avatarRef: StorageReference {
        UserModel.avatarRef(byId: documentId!)
    }
    
}
