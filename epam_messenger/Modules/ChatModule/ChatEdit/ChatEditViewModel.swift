//
//  ChatEditViewModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 21.04.2020.
//

import UIKit
import SDWebImage

protocol ChatEditViewModelProtocol {
    var chatModel: ChatModel { get set }
    var chatAvatar: UIImage? { get set }
    
    func updateChat(completion: @escaping (Error?) -> Void)
}

class ChatEditViewModel: ChatEditViewModelProtocol {
    
    // MARK: - Vars
    
    let router: RouterProtocol
    let viewController: ChatEditViewControllerProtocol
    let firestoreService: FirestoreServiceProtocol
    let storageService: StorageServiceProtocol
    
    var chatModel: ChatModel
    var chatAvatar: UIImage?
    
    // MARK: - Init
    
    init(
        router: RouterProtocol,
        viewController: ChatEditViewControllerProtocol,
        chatModel: ChatModel,
        firestoreService: FirestoreServiceProtocol = FirestoreService(),
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.router = router
        self.viewController = viewController
        self.chatModel = chatModel
        self.firestoreService = firestoreService
        self.storageService = storageService
    }
    
    // MARK: - Actions
    
    func updateChat(completion: @escaping (Error?) -> Void) {
        let updateGroup = DispatchGroup()
        var err: Error?
        let avatarTimestamp = chatAvatar != nil ? Date() : nil
        
        if let chatAvatar = chatAvatar {
            updateGroup.enter()
            storageService.uploadChatAvatar(
                chatId: chatModel.documentId,
                avatar: chatAvatar,
                timestamp: avatarTimestamp!
            ) { kind, avatarErr in
                if let avatarErr = avatarErr {
                    err = avatarErr
                }
                self.chatModel.type.changeChat(newAvatarPath: kind!.path)
                updateGroup.leave()
            }
        }
        
        updateGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.firestoreService.updateChat(self.chatModel) { chatErr in
                if let chatErr = chatErr {
                    err = chatErr
                }
                completion(err)
            }
        }
    }
    
}
