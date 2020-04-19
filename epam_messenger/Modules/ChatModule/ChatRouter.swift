//
//  ChatRouter.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 09.04.2020.
//

import Foundation

protocol ChatRouter {
    func showChat(_ chat: ChatProtocol)
    func showChat(_ userId: String)
    func showChatDetails(_ chat: ChatProtocol, from chatViewController: ChatViewControllerProtocol?, heroAnimations: Bool)
    func showChatDetails(_ userId: String, from chatViewController: ChatViewControllerProtocol?, heroAnimations: Bool)
}

extension ChatRouter {
    func showChatDetails(_ chat: ChatProtocol, from chatViewController: ChatViewControllerProtocol? = nil, heroAnimations: Bool = true) {
        showChatDetails(chat, from: chatViewController, heroAnimations: heroAnimations)
    }
    func showChatDetails(_ userId: String, from chatViewController: ChatViewControllerProtocol? = nil, heroAnimations: Bool = true) {
        showChatDetails(userId, from: chatViewController, heroAnimations: heroAnimations)
    }
}

extension Router: ChatRouter {
    
    func showChat(_ userId: String) {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder = assemblyBuilder as? ChatAssemblyBuilder else { return }
        let chatViewController = assemblyBuilder.createChat(router: self, userId: userId)
        navigationController.pushViewController(chatViewController, animated: true)
    }
    
    func showChat(_ chat: ChatProtocol) {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder = assemblyBuilder as? ChatAssemblyBuilder else { return }
        let chatViewController = assemblyBuilder.createChat(router: self, chat: chat)
        navigationController.pushViewController(chatViewController, animated: true)
    }
    
    func showChatDetails(_ chat: ChatProtocol, from chatViewController: ChatViewControllerProtocol?, heroAnimations: Bool) {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder = assemblyBuilder as? ChatAssemblyBuilder else { return }
        let chatDetailsViewController = assemblyBuilder.createChatDetails(
            router: self,
            chat: chat,
            from: chatViewController,
            heroAnimations: heroAnimations
        )
        navigationController.present(chatDetailsViewController, animated: true, completion: nil)
    }
    
    func showChatDetails(_ userId: String, from chatViewController: ChatViewControllerProtocol?, heroAnimations: Bool) {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder = assemblyBuilder as? ChatAssemblyBuilder else { return }
        let chatDetailsViewController = assemblyBuilder.createChatDetails(
            router: self,
            userId: userId,
            from: chatViewController,
            heroAnimations: heroAnimations
        )
        navigationController.present(chatDetailsViewController, animated: true, completion: nil)
    }
    
}
