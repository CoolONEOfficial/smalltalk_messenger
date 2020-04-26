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
    func popToRoot()
    func showContactsList()
    func showUserPicker(selectDelegate: ContactsSelectDelegate)
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    var isAuthorized: Bool {
        return Auth.auth().currentUser != nil
    }
    
    var rootViewController: UIViewController? {
        try! Auth.auth().signOut()
        if isAuthorized {
            return assemblyBuilder?.createBottomBarModule(router: self)
        } else {
            guard let assemblyBuilder = assemblyBuilder as? AuthAssemblyBuilder else { return nil }
            return assemblyBuilder.createAuthStart(router: self)
        }
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
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    func showContactsList() {
        if let navigationController = navigationController {
            guard let contactsListViewController = assemblyBuilder?.createContactsListModule(router: self, selectDelegate: nil) else { return }
            navigationController.viewControllers = [contactsListViewController]
        }
    }
    
    func showUserPicker(selectDelegate: ContactsSelectDelegate) {
        if let contactsController = assemblyBuilder?.createContactsListModule(
            router: self,
            selectDelegate: selectDelegate
        ) {
            let navigationController = UINavigationController(rootViewController: contactsController)
            navigationController.view.tintColor = .accent
            Router.topMostController.present(navigationController, animated: true, completion: nil)
        }
    }
    
    init(navigationController: UINavigationController,
         assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    // MARK: - Helpers
    
    static var topMostController: UIViewController {
        var topController: UIViewController = UIApplication.keyWindow!.rootViewController!
        while topController.presentedViewController != nil {
            topController = topController.presentedViewController!
        }
        return topController
    }
}
