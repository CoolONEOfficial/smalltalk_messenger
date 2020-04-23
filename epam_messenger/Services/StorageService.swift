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
        completion: @escaping (Error?) -> Void
    )
    func uploadChatAvatar(
        chatId: String,
        avatar: UIImage,
        completion: @escaping (Error?) -> Void
    )
    func uploadImage(
        chatId: String,
        image: UIImage,
        timestamp: Date,
        index: Int,
        completion: @escaping (MessageModel.MessageKind?, Error?) -> Void
    )
    func uploadAudio(
        chatId: String,
        data: Data,
        completion: @escaping (MessageModel.MessageKind?, Error?) -> Void
    )
}

extension StorageServiceProtocol {
    func uploadImage(
        chatId: String,
        image: UIImage,
        timestamp: Date,
        index: Int,
        completion: @escaping (MessageModel.MessageKind?, Error?) -> Void = {_, _ in}
    ) {
        uploadImage(chatId: chatId, image: image, timestamp: timestamp, index: index, completion: completion)
    }
    func uploadAudio(
        chatId: String,
        data: Data,
        completion: @escaping (MessageModel.MessageKind?, Error?) -> Void = {_, _ in}
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
        completion: @escaping (MessageModel.MessageKind?, Error?) -> Void
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
        completion: @escaping (MessageModel.MessageKind?, Error?) -> Void
    ) {
        let metadata = StorageMetadata()
        metadata.contentType = "audio/x-m4a"
        
        storage.child("chats")
            .child(chatId)
            .child("audio")
            .child("\(Date().iso8601withFractionalSeconds).m4a")
            .putData(data, metadata: metadata) { metadata, err in
                guard err == nil else {
                    completion(nil, err)
                    return
                }
                
                let path = metadata!.path!
                completion(.audio(
                    path: path
                ), err)
        }
    }
    
    func uploadUserAvatar(
        userId: String,
        avatar: UIImage,
        completion: @escaping (Error?) -> Void
    ) {
        uploadImage(
            avatar,
            to: storage.child("users")
                .child(userId)
                .child("avatar.jpg")
        ) { kind, err in
            completion(err)
        }
    }
    
    func uploadChatAvatar(
        chatId: String,
        avatar: UIImage,
        completion: @escaping (Error?) -> Void
    ) {
        uploadImage(
            avatar,
            to: storage.child("chats")
                .child(chatId)
                .child("avatar.jpg")
        ) { kind, err in
            completion(err)
        }
    }
    
    // MARK: - Helpers
    
    private func uploadImage(
        _ image: UIImage,
        to imageRef: StorageReference,
        completion: @escaping (MessageModel.MessageKind?, Error?) -> Void
    ) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let data = image.jpegData(compressionQuality: 0.9)!
        imageRef.putData(data, metadata: metadata) { metadata, err in
            guard err == nil else {
                completion(nil, err)
                return
            }
        
            self.waitSmallImageCreation(imageRef) {
                completion(.image(
                    path: metadata!.path!,
                    size: image.size
                ), nil)
            }
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
