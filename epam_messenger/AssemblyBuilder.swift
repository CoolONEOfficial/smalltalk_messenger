//
//  AssemblyBuilder.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createAuthorizationModule(router: RouterProtocol) -> UIViewController
    func createChatsModule(router: RouterProtocol) -> UIViewController
    func createChatModule(router: RouterProtocol) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createAuthorizationModule(router: RouterProtocol) -> UIViewController {
        let view = AuthorizationViewController()
        let viewModel = AuthorizationViewModel(router: router)
        view.viewModel = viewModel
        return view
    }
    
    func createChatsModule(router: RouterProtocol) -> UIViewController {
        let view = ChatsViewController()
        let viewModel = ChatsViewModel(router: router)
        view.viewModel = viewModel
        return view
    }
    
    func createChatModule(router: RouterProtocol) -> UIViewController {
        let view = ChatViewController()
        let viewModel = ChatViewModel(router: router)
        view.viewModel = viewModel
        return view
    }
}
