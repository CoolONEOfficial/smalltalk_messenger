//
//  User.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 02.04.2020.
//

import Foundation
import FirebaseStorage

protocol UserProtocol {
    var fullName: String { get }
    var placeholderName: String { get }
    var onlineText: String { get }
    var avatarRef: StorageReference { get }
    var color: UIColor { get set }
    
    var documentId: String? { get }
    var name: String { get }
    var surname: String { get }
    var phoneNumber: String { get }
    var isAvatarExists: String? { get set }
    var online: Bool { get }
    var typing: String? { get }
    var deleted: Bool { get }
}
