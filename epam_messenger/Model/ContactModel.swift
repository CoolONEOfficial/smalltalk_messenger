//
//  ContactsListModel.swift
//  epam_messenger
//
//  Created by Maxim on 25.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

public struct ContactModel: AutoCodable, AutoEquatable {
    var documentId: String?
    let localName: String
    let userId: String
    
    static func fromUser(_ user: UserProtocol) -> ContactModel {
        .init(localName: user.fullName, userId: user.documentId!)
    }
    
    static func fromSnapshot(_ snapshot: DocumentSnapshot) -> ContactModel? {
        var data = snapshot.data() ?? [:]
        data["documentId"] = snapshot.documentID
        
        do {
            return try FirestoreDecoder()
                .decode(
                    ContactModel.self,
                    from: data
            )
        } catch let err {
            debugPrint("error while parse test model: \(err) 11111")
            return nil
        }
    }
}
