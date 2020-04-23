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
        timestamp: Date,
        completion: @escaping ((path: String, size: ImageSize)?, Error?) -> Void
    )
    func uploadImage(
        chatId: String,
        image: UIImage,
        timestamp: Date,
        index: Int,
        completion: @escaping ((path: String, size: ImageSize)?, Error?) -> Void
    )
    func uploadAudio(
        chatId: String,
        data: Data,
        completion: @escaping (_ path: String?, Error?) -> Void
    )
}

extension StorageServiceProtocol {
    func uploadImage(
        chatId: String,
        image: UIImage,
        timestamp: Date,
        index: Int,
        completion: @escaping ((path: String, size: ImageSize)?, Error?) -> Void = {_, _ in}
    ) {
        uploadImage(chatId: chatId, image: image, timestamp: timestamp, index: index, completion: completion)
    }
    func uploadAudio(
        chatId: String,
        data: Data,
        completion: @escaping (_ path: String?, Error?) -> Void = {_, _ in}
    ) {
        uploadAudio(chatId: chatId, data: data, completion: completion)
    }
}

class StorageService: StorageServiceProtocol {
    static let storage = Storage.storage().reference()
    
    func uploadImage(
        chatId: String,
        image: UIImage,
        timestamp: Date,
        index: Int,
        completion: @escaping ((path: String, size: ImageSize)?, Error?) -> Void
    ) {
        uploadImage(
            image,
            to: StorageService.storage.child("chats")
                .child(chatId)
                .child("media")
                .child("\(timestamp.iso8601withFractionalSeconds)_\(index).jpg"),
            completion: completion
        )
    }
    
    func uploadAudio(
        chatId: String,
        data: Data,
        completion: @escaping (_ path: String?, Error?) -> Void
    ) {
        let metadata = StorageMetadata()
        metadata.contentType = "audio/x-m4a"
        
        StorageService.storage.child("chats")
            .child(chatId)
            .child("audio")
            .child("\(Date().iso8601withFractionalSeconds).m4a")
            .putData(data, metadata: metadata) { metadata, err in
                guard err == nil else {
                    completion(nil, err)
                    return
                }
                
                let path = metadata!.path!
                completion(path, err)
        }
    }
    
    static func getUserAvatarRef(_ userId: String) -> StorageReference {
        StorageService.storage.child("users")
            .child(userId)
            .child("avatar.jpg")
    }
    
    func uploadUserAvatar(
        userId: String,
        avatar: UIImage,
        completion: @escaping (Error?) -> Void
    ) {
        let ref = StorageService.getUserAvatarRef(userId)
        
        ref.small.delete { _ in
            self.uploadImage(
                avatar,
                to: ref
            ) { _, err in
                completion(err)
            }
        }
    }
    
    static func getChatAvatarRef(chatId: String, timestamp: Date) -> StorageReference {
        StorageService.storage.child("chats")
            .child(chatId)
            .child("avatars")
            .child("\(timestamp.iso8601withFractionalSeconds).jpg")
    }
    
    func uploadChatAvatar(
        chatId: String,
        avatar: UIImage,
        timestamp: Date,
        completion: @escaping ((path: String, size: ImageSize)?, Error?) -> Void
    ) {
        uploadImage(
            avatar,
            to: StorageService.getChatAvatarRef(
                chatId: chatId,
                timestamp: timestamp
            )
        ) { kind, err in
            completion(kind, err)
        }
    }
    
    // MARK: - Helpers
    
    private func uploadImage(
        _ image: UIImage,
        to imageRef: StorageReference,
        completion: @escaping ((path: String, size: ImageSize)?, Error?) -> Void
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
                completion((
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
