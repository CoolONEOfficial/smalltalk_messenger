//
//  ContactsListModel.swift
//  epam_messenger
//
//  Created by Maxim on 25.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

struct ContactsListModel: Decodable {
    let localName: String
    let userId: String
    
    static func fromSnapshot(_ snapshot: DocumentSnapshot) -> ContactsListModel? {
        let data = snapshot.data() ?? [:]
        
        do {
            return try FirestoreDecoder()
                .decode(
                    ContactsListModel.self,
                    from: data
            )
        } catch let err {
            debugPrint("error while parse test model: \(err) 11111")
            return nil
        }
    }
}
