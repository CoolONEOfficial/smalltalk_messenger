//
//  ChatAssemblyBuilder.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 09.04.2020.
//

import UIKit

protocol ChatAssemblyBuilder {
    func createChat(router: RouterProtocol, chat: ChatProtocol) -> UIViewController
    func createChat(router: RouterProtocol, userId: String) -> UIViewController
    func createChatDetails(
        router: RouterProtocol,
        chatModel: ChatModel,
        from chatViewController: ChatViewControllerProtocol?,
        heroAnimations: Bool
    ) -> UIViewController
    func createChatDetails(
        router: RouterProtocol,
        userId: String,
        from chatViewController: ChatViewControllerProtocol?,
        heroAnimations: Bool
    ) -> UIViewController
    func createChatEdit(router: RouterProtocol, chatModel: ChatModel) -> UIViewController
}

extension AssemblyBuilder: ChatAssemblyBuilder {
    
    func createChat(
        router: RouterProtocol,
        chat: ChatProtocol
    ) -> UIViewController {
        let view = ChatViewController()
        let viewModel = ChatViewModel(
            router: router,
            viewController: view,
            chat: chat
        )
        view.viewModel = viewModel
        return view
    }
    
    func createChat(
        router: RouterProtocol,
        userId: String
    ) -> UIViewController {
        let view = ChatViewController()
        let viewModel = ChatViewModel(
            router: router,
            viewController: view,
            userId: userId
        )
        view.viewModel = viewModel
        return view
    }
    
    func createChatDetails(
        router: RouterProtocol,
        chatModel: ChatModel,
        from chatViewController: ChatViewControllerProtocol?,
        heroAnimations: Bool
    ) -> UIViewController {
        let view = ChatDetailsViewController()
        let viewModel = ChatDetailsViewModel(
            router: router,
            viewController: view,
            chatModel: chatModel
        )
        view.viewModel = viewModel
        view.chatViewController =  chatViewController
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.modalPresentationStyle = .fullScreen
        if heroAnimations {
            view.hero.isEnabled = true
            navigationController.hero.isEnabled = true
        }
        return navigationController
    }
    
    func createChatDetails(
        router: RouterProtocol,
        userId: String,
        from chatViewController: ChatViewControllerProtocol?,
        heroAnimations: Bool
    ) -> UIViewController {
        let view = ChatDetailsViewController()
        let viewModel = ChatDetailsViewModel(
            router: router,
            viewController: view,
            userId: userId
        )
        view.viewModel = viewModel
        view.chatViewController =  chatViewController
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.modalPresentationStyle = .fullScreen
        if heroAnimations {
            view.hero.isEnabled = true
            navigationController.hero.isEnabled = true
        }
        return navigationController
    }
    
    func createChatEdit(router: RouterProtocol, chatModel: ChatModel) -> UIViewController {
        let view = ChatEditViewController()
        let viewModel = ChatEditViewModel(
            router: router,
            viewController: view,
            chatModel: chatModel
        )
        view.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.view.tintColor = .accent
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
    
}
