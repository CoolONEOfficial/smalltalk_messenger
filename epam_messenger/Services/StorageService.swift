//
//  StorageService.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 23.03.2020.
//

import FirebaseStorage

protocol StorageServiceProtocol: AutoMockable {
    func uploadImage(
        chatDocumentId: String,
        image: UIImage,
        timestamp: Date,
        index: Int,
        completion: @escaping (MessageModel.MessageKind?) -> Void
    )
    func uploadAudio(
        chatDocumentId: String,
        data: Data,
        completion: @escaping (MessageModel.MessageKind?) -> Void
    )
}

extension StorageServiceProtocol {
    func uploadImage(
        chatDocumentId: String,
        image: UIImage,
        timestamp: Date,
        index: Int,
        completion: @escaping (MessageModel.MessageKind?) -> Void = {_ in}
    ) {
        uploadImage(chatDocumentId: chatDocumentId, image: image, timestamp: timestamp, index: index, completion: completion)
    }
    func uploadAudio(
        chatDocumentId: String,
        data: Data,
        completion: @escaping (MessageModel.MessageKind?) -> Void = {_ in}
    ) {
        uploadAudio(chatDocumentId: chatDocumentId, data: data, completion: completion)
    }
}

class StorageService: StorageServiceProtocol {
    lazy var storage = Storage.storage().reference()
    
    func uploadImage(
        chatDocumentId: String,
        image: UIImage,
        timestamp: Date,
        index: Int,
        completion: @escaping (MessageModel.MessageKind?) -> Void = {_ in}
    ) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        if let data = image.jpegData(compressionQuality: 0.9) {
            storage.child("chats")
                .child(chatDocumentId)
                .child("media")
                .child("\(timestamp.iso8601withFractionalSeconds)_\(index).jpg")
                .putData(data, metadata: metadata) { metadata, _ in
                    if let path = metadata?.path {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // wait firebase functions
                            completion(.image(
                                path: path,
                                size: image.size
                            ))
                        }
                    } else {
                        completion(nil)
                    }
            }
        } else {
            completion(nil)
        }
    }
    
    func uploadAudio(
        chatDocumentId: String,
        data: Data,
        completion: @escaping (MessageModel.MessageKind?) -> Void
    ) {
        let metadata = StorageMetadata()
        metadata.contentType = "audio/x-m4a"
        
        storage.child("chats")
            .child(chatDocumentId)
            .child("audio")
            .child("\(Date().iso8601withFractionalSeconds).m4a")
            .putData(data, metadata: metadata) { metadata, _ in
                if let path = metadata?.path {
                    completion(.audio(
                        path: path
                        ))
                } else {
                    completion(nil)
                }
        }
    }
}
