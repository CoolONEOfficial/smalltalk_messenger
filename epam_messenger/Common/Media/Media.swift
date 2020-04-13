//
//  Media.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 10.04.2020.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

protocol MediaProtocol {
    var ref: StorageReference { get }
    
    var path: String { get }
    var size: ImageSize { get }
    var timestamp: Timestamp { get }
}
