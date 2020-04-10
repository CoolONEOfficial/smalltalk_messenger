//
//  ChatAssemblyBuilder.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 09.04.2020.
//

import UIKit

protocol ChatAssemblyBuilder {
    func createChat(router: RouterProtocol, chat: ChatProtocol) -> UIViewController
    func createChatDetails(router: RouterProtocol, chat: ChatProtocol) -> UIViewController
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
    
    func createChatDetails(
        router: RouterProtocol,
        chat: ChatProtocol
    ) -> UIViewController {
        let view = ChatDetailsViewController()
        let viewModel = ChatDetailsViewModel(
            router: router,
            viewController: view,
            chat: chat
        )
        view.viewModel = viewModel
        view.hero.isEnabled = true
        let navigationController = UINavigationController(rootViewController: view)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.hero.isEnabled = true
        navigationController.view.tintColor = .accent
        return navigationController
    }
    
}
