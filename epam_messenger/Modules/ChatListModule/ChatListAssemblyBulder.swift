//
//  ChatListAssemblyBulder.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 20.04.2020.
//

import UIKit

protocol ChatListAssemblyBuilder {
    func createChatCreateModule(router: RouterProtocol) -> UIViewController
    func createChatListModule(router: RouterProtocol, selectDelegate: ChatSelectDelegate?) -> UIViewController
}

extension AssemblyBuilder: ChatListAssemblyBuilder {
    
    func createChatCreateModule(router: RouterProtocol) -> UIViewController {
        let view = ChatCreateViewController()
        let viewModel = ChatCreateViewModel(
            router: router,
            viewController: view
        )
        view.viewModel = viewModel
        return view
    }
    
    func createChatListModule(
        router: RouterProtocol,
        selectDelegate: ChatSelectDelegate? = nil
    ) -> UIViewController {
        let view = ChatListViewController()
        view.forwardDelegate = selectDelegate
        let viewModel = ChatListViewModel(
            router: router,
            viewController: view
        )
        view.viewModel = viewModel
        return view
    }
    
}
