//
//  StorageService.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 23.03.2020.
//

import FirebaseStorage

protocol StorageServiceProtocol: AutoMockable {
    func uploadUserAvatar(
        userId: String,
        avatar: UIImage,
        completion: @escaping (Bool) -> Void
    )
    func uploadImage(
        chatId: String,
        image: UIImage,
        timestamp: Date,
        index: Int,
        completion: @escaping (MessageModel.MessageKind?) -> Void
    )
    func uploadAudio(
        chatId: String,
        data: Data,
        completion: @escaping (MessageModel.MessageKind?) -> Void
    )
}

extension StorageServiceProtocol {
    func uploadImage(
        chatId: String,
        image: UIImage,
        timestamp: Date,
        index: Int,
        completion: @escaping (MessageModel.MessageKind?) -> Void = {_ in}
    ) {
        uploadImage(chatId: chatId, image: image, timestamp: timestamp, index: index, completion: completion)
    }
    func uploadAudio(
        chatId: String,
        data: Data,
        completion: @escaping (MessageModel.MessageKind?) -> Void = {_ in}
    ) {
        uploadAudio(chatId: chatId, data: data, completion: completion)
    }
}

class StorageService: StorageServiceProtocol {
    lazy var storage = Storage.storage().reference()
    
    func uploadImage(
        chatId: String,
        image: UIImage,
        timestamp: Date,
        index: Int,
        completion: @escaping (MessageModel.MessageKind?) -> Void
    ) {
        uploadImage(
            image,
            to: storage.child("chats")
                .child(chatId)
                .child("media")
                .child("\(timestamp.iso8601withFractionalSeconds)_\(index).jpg"),
            completion: completion
        )
    }
    
    func uploadAudio(
        chatId: String,
        data: Data,
        completion: @escaping (MessageModel.MessageKind?) -> Void
    ) {
        let metadata = StorageMetadata()
        metadata.contentType = "audio/x-m4a"
        
        storage.child("chats")
            .child(chatId)
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
    
    func uploadUserAvatar(
        userId: String,
        avatar: UIImage,
        completion: @escaping (Bool) -> Void
    ) {
        uploadImage(
            avatar,
            to: storage.child("users")
                .child(userId)
                .child("avatar.jpg")
        ) { kind in
                completion(kind != nil)
        }
    }
    
    // MARK: - Helpers
    
    private func uploadImage(
        _ image: UIImage,
        to imageRef: StorageReference,
        completion: @escaping (MessageModel.MessageKind?) -> Void
    ) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        if let data = image.jpegData(compressionQuality: 0.9) {
            imageRef.putData(data, metadata: metadata) { metadata, _ in
                    if let path = metadata?.path {
                        self.waitSmallImageCreation(imageRef) {
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
    
    private func waitSmallImageCreation(
        _ ref: StorageReference,
        completion: @escaping () -> Void
    ) {
        ref.small.getMetadata { _, error in

            if error != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.waitSmallImageCreation(ref, completion: completion)
                }
            } else {
                completion()
            }
        }
    }
}
