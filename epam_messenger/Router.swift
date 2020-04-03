//
//  Router.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import UIKit
import FirebaseAuth

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain, AutoMockable {
    func initialViewController()
    func showBottomBar()
    func showChatList()
    func showChat(_ chatModel: ChatModel)
    func popToRoot()
    func showContactsList()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    var isAuthorized: Bool {
        return Auth.auth().currentUser != nil
    }
    
    var rootViewController: UIViewController? {
        if isAuthorized {
            return assemblyBuilder?.createBottomBarModule(router: self)
        } else {
            guard let assemblyBuilder = assemblyBuilder as? AuthAssemblyBuilder else { return UIViewController() }
            return assemblyBuilder.createAuthStart(router: self)
        }
    }
    
    func initialViewController() {
//        if let navigationController = navigationController, let rootViewController = rootViewController {
//            navigationController.viewControllers = [rootViewController]
//        }
        
        if let navigationController = navigationController {
            guard let contactsListViewController = assemblyBuilder?.createContactsListModule(router: self) else { return }
            navigationController.viewControllers = [contactsListViewController]
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
    
    func showContactsList() {
//        if let navigationController = navigationController {
//            guard let contactsListViewController = assemblyBuilder?.createContactsListModule(router: self) else { return }
//            navigationController.viewControllers = [contactsListViewController]
//        }
    }
    
    init(navigationController: UINavigationController,
         assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
}
