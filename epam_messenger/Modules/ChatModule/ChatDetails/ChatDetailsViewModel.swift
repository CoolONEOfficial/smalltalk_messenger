//
//  ChatDetailsViewModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 09.04.2020.
//

import Foundation
import UIKit

protocol ChatDetailsViewModelProtocol {
    var chatModel: ChatModel { get }
    var chatGroup: DispatchGroup { get }
    var router: RouterProtocol { get }
    
    func listenChatData(completion: @escaping (ChatModel?) -> Void)
    func listenUserData(completion: @escaping (UserModel?) -> Void)
    func checkContactExists(completion: @escaping (Bool?, Error?) -> Void)
    func showChatEdit()
    func inviteUser()
    func addContact(completion: @escaping (Error?) -> Void)
}

class ChatDetailsViewModel: ChatDetailsViewModelProtocol {
    
    // MARK: - Vars
    
    let router: RouterProtocol
    let viewController: ChatDetailsViewControllerProtocol
    let firestoreService: FirestoreServiceProtocol
    
    var chatModel: ChatModel
    var friendModel: UserProtocol?
    var chatGroup = DispatchGroup()
    
    // MARK: - Init
    
    init(
        router: RouterProtocol,
        viewController: ChatDetailsViewControllerProtocol,
        chatModel: ChatModel,
        firestoreService: FirestoreServiceProtocol = FirestoreService()
    ) {
        self.router = router
        self.viewController = viewController
        self.chatModel = chatModel
        self.firestoreService = firestoreService
    }
    
    init(
        router: RouterProtocol,
        viewController: ChatDetailsViewControllerProtocol,
        userId: String,
        firestoreService: FirestoreServiceProtocol = FirestoreService()
    ) {
        self.router = router
        self.viewController = viewController
        self.chatModel = ChatModel.fromUserId(userId)
        self.firestoreService = firestoreService
        
        chatGroup.enter()
        firestoreService.getChatData(userId: userId) { [weak self] chatModel in
            guard let self = self else { return }
            if let chatModel = chatModel {
                self.chatModel = chatModel
            }
            self.chatGroup.leave()
        }
    }
    
    // MARK: - Methods
    
    func listenChatData(completion: @escaping (ChatModel?) -> Void) {
        guard let chatId = chatModel.documentId else { return }
        
        firestoreService.listenChatData(chatId) { [weak self] chat in
            guard let self = self else { return }
            if let chat = chat {
                self.chatModel = chat
            }
            completion(chat)
        }
    }
    
    func listenUserData(completion: @escaping (UserModel?) -> Void) {
        guard let friendId = chatModel.friendId else { return }
        firestoreService.listenUserData(friendId) { user in
            self.friendModel = user
            completion(user)
        }
    }
    
    func checkContactExists(completion: @escaping (Bool?, Error?) -> Void) {
        guard let friendId = chatModel.friendId else { return }
        firestoreService.getContact(friendId) { contactModel, err in
            completion(contactModel != nil, err)
        }
    }
    
    func inviteUser() {
        router.showUserPicker(selectDelegate: self)
    }
    
    func addContact(completion: @escaping (Error?) -> Void) {
        if let friendModel = friendModel {
            firestoreService.createContact(.fromUser(friendModel), completion: completion)
        }
    }
    
    func showChatEdit() {
        guard let router = router as? ChatRouter else { return }
        router.showChatEdit(chatModel)
    }
}

extension ChatDetailsViewModel: ContactsSelectDelegate {
    
    func didSelectUser(_ userId: String) {
        firestoreService.inviteChatUser(chatId: chatModel.documentId!, userId: userId, completion: {_ in})
    }
    
}
