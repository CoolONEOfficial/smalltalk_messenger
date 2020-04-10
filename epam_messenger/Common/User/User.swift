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
    var onlineText: String { get }
    var avatarRef: StorageReference { get }
    
    var documentId: String? { get }
    var name: String { get }
    var surname: String { get }
    var online: Bool { get }
    var typing: String? { get }
}
