//
//  ContactsListModel.swift
//  epam_messenger
//
//  Created by Maxim on 25.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

public struct ContactModel: Decodable, AutoEquatable {
    let localName: String
    let userId: String
    
    static func fromSnapshot(_ snapshot: DocumentSnapshot) -> ContactModel? {
        let data = snapshot.data() ?? [:]
        
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
