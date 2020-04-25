//
//  ChatEditViewModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 21.04.2020.
//

import UIKit
import SDWebImage

protocol ChatEditViewModelProtocol {
    var contactModel: ContactModel! { get set }
    var contactGroup: DispatchGroup { get }
    
    var chatModel: ChatModel { get set }
    var chatAvatar: UIImage? { get set }
    
    func loadFriend(completion: @escaping (UserModel?) -> Void)
    func applyChanges(completion: @escaping (Error?) -> Void)
}

class ChatEditViewModel: ChatEditViewModelProtocol {
    
    // MARK: - Vars
    
    let router: RouterProtocol
    let viewController: ChatEditViewControllerProtocol
    let firestoreService: FirestoreServiceProtocol
    let storageService: StorageServiceProtocol
    
    var contactModel: ContactModel!
    
    var chatModel: ChatModel
    var chatAvatar: UIImage?
    
    let contactGroup = DispatchGroup()
    
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
        
        if case .personalCorr = chatModel.type {
            contactGroup.enter()
            firestoreService.getContact(chatModel.friendId!) { [weak self] contactModel, err in
                guard let self = self else { return }
                self.contactModel = contactModel
                self.contactGroup.leave()
            }
        }
    }
    
    // MARK: - Actions
    
    func applyChanges(completion: @escaping (Error?) -> Void) {
        switch chatModel.type {
        case .personalCorr:
            updateContact(completion: completion)
        case .chat:
            updateChat(completion: completion)
        default: break
        }
    }
    
    private func updateContact(completion: @escaping (Error?) -> Void) {
        firestoreService.updateContact(
            userId: chatModel.friendId!,
            contactModel: contactModel,
            completion: completion
        )
    }
    
    private func updateChat(completion: @escaping (Error?) -> Void) {
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
    
    func loadFriend(completion: @escaping (UserModel?) -> Void) {
        firestoreService.listenUserData(chatModel.friendId!, completion: completion)
    }
    
}
