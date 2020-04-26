//
//  Chat.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 02.04.2020.
//

import Foundation
import FirebaseStorage
import CodableFirebase
import FirebaseFirestore

protocol ChatProtocol {
    var friendId: String? { get }
    var friendName: String? { get }
    var avatarRef: StorageReference? { get }
    func listenInfo(completion: @escaping (
        _ title: String,
        _ subtitle: String,
        _ placeholderText: String?,
        _ placeholderColor: UIColor?
    ) -> Void)
    
    var documentId: String! { get set }
    var users: [String] { get }
    var lastMessage: MessageModel { get }
    var type: ChatType { get set }
}

public enum ChatType: AutoCodable, AutoEquatable {
    case personalCorr(
        between: [String],
        betweenNames: [String]
    )
    case savedMessages
    case chat(
        title: String,
        adminId: String,
        hexColor: String?,
        avatarPath: String?
    )
    
    mutating func changeChat(
        newTitle: String? = nil,
        newAdminId: String? = nil,
        newHexColor: String? = nil,
        newAvatarPath: String? = nil,
        clearAvatarPath: Bool? = nil
    ) {
        switch self {
        case .chat(let title, let adminId, let hexColor, let avatarPath):
            self = .chat(
                title: newTitle ?? title,
                adminId: newAdminId ?? adminId,
                hexColor: newHexColor ?? hexColor,
                avatarPath: clearAvatarPath ?? false
                    ? nil
                    : newAvatarPath ?? avatarPath
            )
        default:
            break
        }
    }
    
    

}
