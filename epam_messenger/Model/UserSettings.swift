//
//  UserSettings.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 13.03.2020.
//

import Foundation
import Firebase

struct UserSettingsModel: Codable {
    
    let userId: String
    let userPhoneNumber: String
    let userLogin: String?
    let userName: String?
    let userStatus: String
    //let userImage: UIImage?
    
    static func empty() -> UserSettingsModel {
        return UserSettingsModel(userId: "", userPhoneNumber: "", userLogin: "", userName: "", userStatus: ""/*, userImage: UIImage.init()*/)
    }
}
