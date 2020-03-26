//
//  AssemblyBuilder.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createBottomBarModule(router: RouterProtocol) -> UIViewController
    func createChatListModule(router: RouterProtocol) -> UIViewController
    func createChatModule(router: RouterProtocol, chatModel: ChatModel) -> UIViewController
    func createContactsListModule(router: RouterProtocol) -> UIViewController // me
    func createUserContactsListModule(router: RouterProtocol) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createBottomBarModule(router: RouterProtocol) -> UIViewController {
        let view = BottomBarViewController()
        view.chatList = createChatListModule(router: router)
        view.contacts = createChatListModule(router: router) // TODO: contacts
        view.settings = createChatListModule(router: router) // TODO: settings
        return view
    }
    
    func createChatListModule(router: RouterProtocol) -> UIViewController {
        let view = ChatListViewController()
        let viewModel = ChatListViewModel(router: router, viewController: view)
        view.viewModel = viewModel
        return view
    }
    
    func createChatModule(router: RouterProtocol, chatModel: ChatModel) -> UIViewController {
        let view = ChatViewController()
        let viewModel = ChatViewModel(
            viewController: view,
            router: router,
            chatModel: chatModel
        )
        view.viewModel = viewModel
        return view
    }
    
    func createContactsListModule(router: RouterProtocol) -> UIViewController {
        let view = ContactsListViewController()
        let viewModel = ContactsListViewModel(router: router, viewController: view)
        view.viewModel = viewModel
        return view
    }
    
    func createUserContactsListModule(router: RouterProtocol) -> UIViewController {
        let view = UserContactsListViewController()
        let viewModel = UserContactsListViewModel(router: router, viewController: view)
        view.viewModel = viewModel
        return view
    }
    
}
