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
    func showChats()
    func showChat()
    func popToRoot()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    var isAuthorized = false
    
    var rootViewController: UIViewController? {
        return isAuthorized ? assemblyBuilder?.createChatsModule(router: self) :
            assemblyBuilder?.createAuthorizationModule(router: self)
    }
    
    func initialViewController() {
        if let navigationController = navigationController, let rootViewController = rootViewController {
            navigationController.viewControllers = [rootViewController]
        }
    }
    
    func showChats() {
        if let navigationController = navigationController {
            guard let chatViewController = assemblyBuilder?.createChatsModule(router: self) else { return }
            navigationController.viewControllers = [chatViewController]
        }
    }
    
    func showChat() {
        if let navigationController = navigationController {
            guard let chatViewController = assemblyBuilder?.createChatModule(router: self) else { return }
            navigationController.pushViewController(chatViewController, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    init(navigationController: UINavigationController,
         assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
}
