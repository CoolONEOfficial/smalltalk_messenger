//
//  UserModel.swift
//  epam_messenger
//
//  Created by Maxim on 13.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

struct UserModel: Decodable {
    let name: String
    let surname: String
    
    static func fromSnapshot(_ snapshot: DocumentSnapshot) -> UserModel? {
        let data = snapshot.data() ?? [:]
        
        do {
            return try FirestoreDecoder()
                .decode(
                    UserModel.self,
                    from: data
            )
        } catch let err {
            debugPrint("error while parse test model: \(err) 11111")
            return nil
        }
    }
}
