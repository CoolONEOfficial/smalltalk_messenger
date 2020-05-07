//
//  AssemblyBuilder.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createBottomBarModule(router: RouterProtocol) -> UIViewController
    func createContactsListModule(router: RouterProtocol, selectDelegate: ContactsSelectDelegate?) -> UIViewController
    func createSettingsStartModule(router: RouterProtocol) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createBottomBarModule(
        router: RouterProtocol
    ) -> UIViewController {
        let view = BottomBarViewController()
        view.chatList = createChatListModule(router: router)
        view.contacts = createContactsListModule(router: router)
        view.settings = createSettingsStartModule(router: router)
        view.viewControllers = view.controllers
        view.selectedIndex = 1
        return view
    }
    
    func createContactsListModule(
        router: RouterProtocol,
        selectDelegate: ContactsSelectDelegate? = nil
    ) -> UIViewController {
        let view = ContactsListViewController()
        view.selectDelegate = selectDelegate
        let viewModel = ContactsListViewModel(
            router: router,
            viewController: view
        )
        view.viewModel = viewModel
        return view
    }
    
    func createSettingsStartModule(router: RouterProtocol) -> UIViewController {
        let view = SettingsStartViewController()
        let viewModel = SettingsStartViewModel(router: router, viewController: view)
        view.viewModel = viewModel
        return view
    }
    
}
