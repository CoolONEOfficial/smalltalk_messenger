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
    func loadInfo(completion: @escaping (
        _ title: String,
        _ subtitle: String,
        _ placeholderText: String,
        _ placeholderColor: UIColor?
    ) -> Void)
    
    var documentId: String! { get set }
    var users: [String] { get }
    var lastMessage: MessageModel { get }
    var type: ChatType { get }
}

public enum ChatType: AutoCodable, AutoEquatable {
    case personalCorr
    case chat(title: String, adminId: String, hexColor: String?)
}
