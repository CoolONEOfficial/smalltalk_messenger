//
//  ChatListRouter.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 20.04.2020.
//

import UIKit

protocol ChatListRouter {
    func showChatList()
    func showChatCreate()
    func showChatPicker(selectDelegate: ChatSelectDelegate)
}

extension Router: ChatListRouter {
    
    func showChatList() {
        guard let navigationController = navigationController,
            let assemblyBuilder = assemblyBuilder as? ChatListAssemblyBuilder else { return }
        let chatViewController = assemblyBuilder.createChatListModule(
            router: self,
            selectDelegate: nil
        )
        navigationController.viewControllers = [chatViewController]
    }
    
    func showChatCreate() {
        guard let navigationController = navigationController,
            let assemblyBuilder = assemblyBuilder as? ChatListAssemblyBuilder else { return }
        let chatViewController = assemblyBuilder.createChatCreateModule(router: self)
        navigationController.pushViewController(chatViewController, animated: true)
    }
    
    func showChatPicker(selectDelegate: ChatSelectDelegate) {
        guard let assemblyBuilder = assemblyBuilder as? ChatListAssemblyBuilder else { return }
        let chatListController = assemblyBuilder.createChatListModule(
            router: self,
            selectDelegate: selectDelegate
        )
        let navigationController = UINavigationController(rootViewController: chatListController)
        navigationController.view.tintColor = .accent
        Router.topMostController.present(navigationController, animated: true, completion: nil)
    }

}
