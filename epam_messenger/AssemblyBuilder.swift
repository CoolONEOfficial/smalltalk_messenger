//
//  AssemblyBuilder.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createBottomBarModule(router: RouterProtocol) -> UIViewController
    func createChatListModule(router: RouterProtocol, forwardDelegate: ForwardDelegateProtocol?) -> UIViewController
    func createChatModule(router: RouterProtocol, chatModel: ChatModel) -> UIViewController
    func createUsersListModule(router: RouterProtocol) -> UIViewController
    func createContactsListModule(router: RouterProtocol) -> UIViewController
}

extension AssemblyBuilderProtocol {
    func createChatListModule(router: RouterProtocol, forwardDelegate: ForwardDelegateProtocol? = nil) -> UIViewController {
        return createChatListModule(router: router, forwardDelegate: forwardDelegate)
    }
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createBottomBarModule(router: RouterProtocol) -> UIViewController {
        let view = BottomBarViewController()
        view.chatList = createChatListModule(router: router)
        view.contacts = createChatListModule(router: router) // TODO: contacts
        view.settings = createChatListModule(router: router) // TODO: settings
        return view
    }
    
    func createChatListModule(router: RouterProtocol, forwardDelegate: ForwardDelegateProtocol? = nil) -> UIViewController {
        let view = ChatListViewController()
        view.forwardDelegate = forwardDelegate
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
    
    func createUsersListModule(router: RouterProtocol) -> UIViewController {
        let view = UsersListViewController()
        let viewModel = UsersListViewModel(router: router, viewController: view)
        view.viewModel = viewModel
        return view
    }
    
}
