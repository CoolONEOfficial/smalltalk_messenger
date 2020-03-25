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
    func listChatFiles(
        chatDocumentId: String,
        completion: @escaping ([StorageReference]?) -> Void
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
     
    func listChatFiles(
        chatDocumentId: String,
        completion: @escaping ([StorageReference]?) -> Void
    ) {
        storage.child("chats").child(chatDocumentId).list(withMaxResults: 20) { result, err in
            guard err == nil else {
                completion(nil)
                return
            }
            
            completion(result.items)
        }
    }
}

// MARK: - ISO8601 date formatter

fileprivate extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

fileprivate extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

fileprivate extension Date {
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
}
