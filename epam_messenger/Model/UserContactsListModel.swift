//
//  UserContactsListModel.swift
//  epam_messenger
//
//  Created by Maxim on 25.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

struct UserContactsListModel: Decodable {
    let localName: String
    let userId: String
    
    static func fromSnapshot(_ snapshot: DocumentSnapshot) -> UserContactsListModel? {
        let data = snapshot.data() ?? [:]
        
        do {
            return try FirestoreDecoder()
                .decode(
                    UserContactsListModel.self,
                    from: data
            )
        } catch let err {
            debugPrint("error while parse test model: \(err) 11111")
            return nil
        }
    }
}
