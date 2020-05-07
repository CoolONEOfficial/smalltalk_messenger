//
//  MediaModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 30.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

public struct MediaModel: AutoDecodable, AutoEquatable {
    let path: String
    let size: ImageSize
    let timestamp: Timestamp
    
    static func fromSnapshot(_ snapshot: DocumentSnapshot) -> MediaModel? {
        let data = snapshot.data() ?? [:]
        
        do {
            return try FirestoreDecoder()
                .decode(
                    MediaModel.self,
                    from: data
            )
        } catch let err {
            debugPrint("error while parse chat media model: \(err)")
            return nil
        }
    }
}

extension MediaModel: MediaProtocol {
    
    var ref: StorageReference {
        Storage.storage().reference(withPath: path)
    }
    
}
