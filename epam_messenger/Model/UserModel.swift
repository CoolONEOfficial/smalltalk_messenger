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
    let typing: String?
    let deleted: Bool
    
    static let defaultDeleted: Bool = false
    static let defaultOnline: Bool = false
    
    static func empty() -> UserModel {
        .init(documentId: nil, name: "", surname: "",
              phoneNumber: Auth.auth().currentUser!.phoneNumber!,
              avatarPath: nil, online: true, typing: nil, deleted: false)
    }
    
    static func deleted(_ documentId: String? = nil) -> UserModel {
        .init(documentId: documentId, name: "DELETED", surname: "", phoneNumber: "",
              hexColor: "#7d7d7d", avatarPath: nil, online: false, typing: nil, deleted: true)
    }
    
    static func saved() -> UserModel {
        .init(documentId: Auth.auth().currentUser!.uid, name: "Saved messages",
              surname: "", phoneNumber: Auth.auth().currentUser!.phoneNumber!,
              hexColor: nil, avatarPath: nil, online: true, typing: nil, deleted: false)
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
        return online
            ? "Online"
            : "Offline"
    }
    
    var avatarRef: StorageReference? {
        avatarPath != nil ? Storage.storage().reference(withPath: avatarPath!) : nil
    }
    
}
