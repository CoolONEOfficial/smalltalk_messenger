//
//  Chat.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 02.04.2020.
//

import Foundation
import FirebaseStorage

protocol ChatProtocol {
    var friendId: String? { get }
    var avatarRef: StorageReference { get }
    
    var documentId: String! { get }
    var users: [String] { get }
    var lastMessage: MessageModel { get }
    var type: ChatType { get }
}

enum ChatType: AutoCodable {
    case personalCorr
    case chat(title: String, adminId: String)
}
