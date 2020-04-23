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
    func didEditTap()
    func didInviteTap()
}

class ChatDetailsViewModel: ChatDetailsViewModelProtocol {
    
    // MARK: - Vars
    
    let router: RouterProtocol
    let viewController: ChatDetailsViewControllerProtocol
    let firestoreService: FirestoreServiceProtocol
    
    var chatModel: ChatModel
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
        firestoreService.listenChatData(chatModel.documentId) { [weak self] chat in
            guard let self = self else { return }
            if let chat = chat {
                self.chatModel = chat
            }
            completion(chat)
        }
    }
    
    func didInviteTap() {
        router.showUserPicker(selectDelegate: self)
    }
    
    func didEditTap() {
        guard let router = router as? ChatRouter else { return }
        router.showChatEdit(chatModel)
    }
}

extension ChatDetailsViewModel: ContactsSelectDelegate {
    
    func didSelectUser(_ userId: String) {
        firestoreService.inviteChatUser(chatId: chatModel.documentId!, userId: userId, completion: {_ in})
    }
    
}
