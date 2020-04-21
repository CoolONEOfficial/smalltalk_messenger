//
//  ChatCreateViewModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 20.04.2020.
//

import UIKit
import SDWebImage

protocol ChatCreateViewModelProtocol {
    func showUserPicker(selectDelegate: ContactsSelectDelegate)
    func createChat(chatModel: ChatModel, avatar: UIImage?, completion: @escaping (Error?) -> Void)
}

class ChatCreateViewModel: ChatCreateViewModelProtocol {
    
    // MARK: - Vars
    
    let router: RouterProtocol
    let viewController: ChatCreateViewControllerProtocol
    let firestoreService: FirestoreServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Init
    
    init(
        router: RouterProtocol,
        viewController: ChatCreateViewControllerProtocol,
        firestoreService: FirestoreServiceProtocol = FirestoreService(),
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.router = router
        self.viewController = viewController
        self.firestoreService = firestoreService
        self.storageService = storageService
    }
    
    // MARK: - Methods
    
    func showUserPicker(selectDelegate: ContactsSelectDelegate) {
        router.showUserPicker(selectDelegate: selectDelegate)
    }
    
    func createChat(chatModel: ChatModel, avatar: UIImage?, completion: @escaping (Error?) -> Void) {
        let chatGroup = DispatchGroup()
        var err: Error?
        
        chatGroup.enter()
        let chatId = firestoreService.createChat(chatModel) { chatErr in
            if chatErr != nil {
                err = chatErr
            }
            chatGroup.leave()
        }
        
        if let avatar = avatar {
            chatGroup.enter()
            storageService.uploadChatAvatar(chatId: chatId, avatar: avatar) { avatarErr in
                if avatarErr != nil {
                    err = avatarErr
                }
                chatGroup.leave()
            }
        }
        
        chatGroup.notify(queue: .main) {
            completion(err)
        }
    }
}
