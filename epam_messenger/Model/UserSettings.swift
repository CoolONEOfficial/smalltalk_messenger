//
//  UserSettings.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 13.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

struct UserSettingsModel: Codable, AutoDecodable {
    
    let userId: String
    let userPhoneNumber: String
 //   let userLastLogin: Timestamp
    
    
    static let defaultUserId: String = ""
    
    
    static func empty() -> UserSettingsModel {
        return UserSettingsModel(userId: "", userPhoneNumber: ""
            //, userLastLogin: Timestamp.init()
        )
    }
    
    static func fromSnapshot(_ snapshot: DocumentSnapshot) -> UserSettingsModel? {
        var data = snapshot.data() ?? [:]
        data["documentId"] = snapshot.documentID
        
        do {
            return try FirestoreDecoder()
                .decode(
                    UserSettingsModel.self,
                    from: data
            )
        } catch let error {
            debugPrint("Error parse user model: \(error)")
            return nil
        }
    }
    
//    static func decodeTimestamp(from container: KeyedDecodingContainer<CodingKeys>) -> Timestamp {
//        if let dict = try? container.decode([String: Int64].self, forKey: .userLastLogin) {
//            return Timestamp.init(
//                seconds: dict["_seconds"]!,
//                nanoseconds: Int32(exactly: dict["_nanoseconds"]!)!
//            )
//        }
//
//        return try! container.decode(Timestamp.self, forKey: .userLastLogin)
//    }
}

//extension UserSettingsModel: UserSettingsViewControllerProtocol {
//    var date: Date {
//        return userLastLogin.dateValue()
//    }
//}
