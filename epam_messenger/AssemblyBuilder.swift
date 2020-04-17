//
//  AssemblyBuilder.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createBottomBarModule(router: RouterProtocol) -> UIViewController
    func createChatListModule(router: RouterProtocol, forwardDelegate: ForwardDelegate?) -> UIViewController
    func createContactsListModule(router: RouterProtocol) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createBottomBarModule(
        router: RouterProtocol
    ) -> UIViewController {
        let view = BottomBarViewController()
        view.chatList = createChatListModule(router: router)
        view.contacts = createContactsListModule(router: router)
        view.settings = createChatListModule(router: router) // TODO: settings
        view.viewControllers = view.controllers
        view.selectedIndex = 1
        return view
    }
    
    func createChatListModule(
        router: RouterProtocol,
        forwardDelegate: ForwardDelegate? = nil
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
    
    func createContactsListModule(router: RouterProtocol) -> UIViewController {
        let view = ContactsListViewController()
        let viewModel = ContactsListViewModel(router: router, viewController: view)
        view.viewModel = viewModel
        return view
    }
    
}
