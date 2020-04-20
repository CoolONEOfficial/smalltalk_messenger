//
//  ChatDetailsViewModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 09.04.2020.
//

import Foundation
import UIKit

protocol ChatDetailsViewModelProtocol {
    var chat: ChatProtocol { get }
    var chatGroup: DispatchGroup { get }
    var router: RouterProtocol { get }
    
    func chatData(completion: @escaping (ChatModel?) -> Void)
    func didInviteTap()
}

class ChatDetailsViewModel: ChatDetailsViewModelProtocol {
    
    // MARK: - Vars
    
    let router: RouterProtocol
    let viewController: ChatDetailsViewControllerProtocol
    let firestoreService: FirestoreServiceProtocol
    
    var chat: ChatProtocol
    var chatGroup = DispatchGroup()
    
    // MARK: - Init
    
    init(
        router: RouterProtocol,
        viewController: ChatDetailsViewControllerProtocol,
        chat: ChatProtocol,
        firestoreService: FirestoreServiceProtocol = FirestoreService()
    ) {
        self.router = router
        self.viewController = viewController
        self.chat = chat
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
        self.chat = ChatModel.fromUserId(userId)
        self.firestoreService = firestoreService
        
        chatGroup.enter()
        firestoreService.getChatData(userId: userId) { [weak self] chatModel in
            guard let self = self else { return }
            if let chatModel = chatModel {
                self.chat = chatModel
            }
            self.chatGroup.leave()
        }
    }
    
    // MARK: - Methods
    
    func chatData(completion: @escaping (ChatModel?) -> Void) {
        firestoreService.listenChatData(chat.documentId) { [weak self] chat in
            guard let self = self else { return }
            if let chat = chat {
                self.chat = chat
            }
            completion(chat)
        }
    }
    
    func didInviteTap() {
        router.showUserPicker(selectDelegate: self)
    }
}

extension ChatDetailsViewModel: ContactsSelectDelegate {
    
    func didSelectUser(_ userId: String) {
        firestoreService.inviteChatUser(chatId: chat.documentId!, userId: userId, completion: {_ in})
    }
    
}
