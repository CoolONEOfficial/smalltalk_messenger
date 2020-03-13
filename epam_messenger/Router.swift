//
//  Router.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showBottomBar()
    func showChatList()
    func showChat(_ chatModel: ChatModel)
    func popToRoot()
    func showUserSettings()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    var isAuthorized = false
    
    var rootViewController: UIViewController? {
        return isAuthorized ? assemblyBuilder?.createChatListModule(router: self) :
            assemblyBuilder?.createAuthorizationModule(router: self)
    }
    
    func initialViewController() {
        if let navigationController = navigationController, let rootViewController = rootViewController {
            navigationController.viewControllers = [rootViewController]
        }
    }
    
    func showBottomBar() {
        if let navigationController = navigationController {
            guard let chatViewController = assemblyBuilder?.createBottomBarModule(router: self) else { return }
            navigationController.viewControllers = [chatViewController]
        }
    }
    
    func showChatList() {
        if let navigationController = navigationController {
            guard let chatViewController = assemblyBuilder?.createChatListModule(router: self) else { return }
            navigationController.viewControllers = [chatViewController]
        }
    }
    
    func showChat(_ chatModel: ChatModel) {
        if let navigationController = navigationController {
            guard let chatViewController =
                assemblyBuilder?.createChatModule(
                    router: self,
                    chatModel: chatModel
                ) else { return }
            navigationController.pushViewController(chatViewController, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func showUserSettings() {
        if let navigationController = navigationController {
            guard let userSettingsViewController = assemblyBuilder?.createChatListModule(router: self) else { return }
            navigationController.viewControllers = [userSettingsViewController]
        }
    }
    
    init(navigationController: UINavigationController,
         assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
}
