//
//  User.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 02.04.2020.
//

import Foundation

protocol UserProtocol {
    var fullName: String { get }
    var onlineText: String { get }
    
    var documentId: String? { get }
    var name: String { get }
    var surname: String { get }
    var online: Bool { get }
}
