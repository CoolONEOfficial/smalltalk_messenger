//
//  ChatRouter.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 09.04.2020.
//

import Foundation

protocol ChatRouter {
    func showChat(_ chat: ChatProtocol)
    func showChat(userId: String)
    func showChat(chatId: String)
    func showChatDetails(_ chatModel: ChatModel, from chatViewController: ChatViewControllerProtocol?, heroAnimations: Bool)
    func showChatDetails(_ userId: String, from chatViewController: ChatViewControllerProtocol?, heroAnimations: Bool)
    func showChatEdit(_ chatModel: ChatModel)
}

extension ChatRouter {
    func showChatDetails(
        _ chatModel: ChatModel,
        from chatViewController: ChatViewControllerProtocol? = nil,
        heroAnimations: Bool = true
    ) {
        showChatDetails(chatModel, from: chatViewController, heroAnimations: heroAnimations)
    }
    func showChatDetails(
        _ userId: String,
        from chatViewController: ChatViewControllerProtocol? = nil,
        heroAnimations: Bool = true
    ) {
        showChatDetails(userId, from: chatViewController, heroAnimations: heroAnimations)
    }
}

extension Router: ChatRouter {
    
    func showChat(userId: String) {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder = assemblyBuilder as? ChatAssemblyBuilder else { return }
        let chatViewController = assemblyBuilder.createChat(router: self, userId: userId)
        navigationController.pushViewController(chatViewController, animated: true)
    }
    
    func showChat(chatId: String) {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder = assemblyBuilder as? ChatAssemblyBuilder else { return }
        let chatViewController = assemblyBuilder.createChat(router: self, chatId: chatId)
        navigationController.pushViewController(chatViewController, animated: true)
    }
    
    func showChat(_ chat: ChatProtocol) {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder = assemblyBuilder as? ChatAssemblyBuilder else { return }
        let chatViewController = assemblyBuilder.createChat(router: self, chat: chat)
        navigationController.pushViewController(chatViewController, animated: true)
    }
    
    func showChatDetails(_ chatModel: ChatModel, from chatViewController: ChatViewControllerProtocol?, heroAnimations: Bool) {
        guard let assemblyBuilder = assemblyBuilder as? ChatAssemblyBuilder else { return }
        let chatDetailsViewController = assemblyBuilder.createChatDetails(
            router: self,
            chatModel: chatModel,
            from: chatViewController,
            heroAnimations: heroAnimations
        )
        chatDetailsViewController.modalTransitionStyle = .crossDissolve
        Router.topMostController.present(chatDetailsViewController, animated: true, completion: nil)
    }
    
    func showChatDetails(_ userId: String, from chatViewController: ChatViewControllerProtocol?, heroAnimations: Bool) {
        guard let assemblyBuilder = assemblyBuilder as? ChatAssemblyBuilder else { return }
        let chatDetailsViewController = assemblyBuilder.createChatDetails(
            router: self,
            userId: userId,
            from: chatViewController,
            heroAnimations: heroAnimations
        )
        chatDetailsViewController.modalTransitionStyle = .crossDissolve
        Router.topMostController.present(chatDetailsViewController, animated: true, completion: nil)
    }
    
    func showChatEdit(_ chatModel: ChatModel) {
        guard let assemblyBuilder = assemblyBuilder as? ChatAssemblyBuilder else { return }
        let chatEditViewController = assemblyBuilder.createChatEdit(
            router: self,
            chatModel: chatModel
        )
        chatEditViewController.modalTransitionStyle = .crossDissolve
        Router.topMostController.present(chatEditViewController, animated: true, completion: nil)
    }
    
}
