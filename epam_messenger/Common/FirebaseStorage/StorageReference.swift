//
//  StorageReference.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 11.04.2020.
//

import FirebaseStorage

extension StorageReference {
    var storageLocation: String {
        "gs://\(bucket)/\(fullPath)"
    }
    
    var smallPath: String {
        var path = fullPath
        path.insert(contentsOf: "_200x200", at: path.index(path.endIndex, offsetBy: -4))
        return path
    }
    
    var small: StorageReference {
        Storage.storage().reference(withPath: smallPath)
    }
}
