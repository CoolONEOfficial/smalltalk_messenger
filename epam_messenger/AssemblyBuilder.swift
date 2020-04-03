//
//  AssemblyBuilder.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createBottomBarModule(
        router: RouterProtocol
    ) -> UIViewController
    func createChatListModule(
        router: RouterProtocol,
        forwardDelegate: ForwardDelegateProtocol?
    ) -> UIViewController
    func createChatModule(
        router: RouterProtocol,
        chat: ChatProtocol
    ) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createBottomBarModule(
        router: RouterProtocol
    ) -> UIViewController {
        let view = BottomBarViewController()
        view.chatList = createChatListModule(
            router: router
        )
        view.contacts = createChatListModule(
            router: router
        ) // TODO: contacts
        view.settings = createChatListModule(
            router: router
        ) // TODO: settings
        return view
    }
    
    func createChatListModule(
        router: RouterProtocol,
        forwardDelegate: ForwardDelegateProtocol? = nil
    ) -> UIViewController {
        let view = ChatListViewController()
        view.forwardDelegate = forwardDelegate
        let viewModel = ChatListViewModel(
            router: router,
            viewController: view
        )
        view.viewModel = viewModel
        return view
    }
    
    func createChatModule(
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
    
}
