//
//  AppCoordinator.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 05.03.2020.
//  Copyright © 2020 Nickolay Truhin. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {
    //private let disposeBag = DisposeBag()
    private var window = UIWindow(frame: UIScreen.main.bounds)
    
    var navigationController = UINavigationController()
    
    func start() {
        self.navigationController.navigationBar.isHidden = true
        self.window.rootViewController = self.navigationController
        self.window.makeKeyAndVisible()
        
        // TODO: here you could check if user is signed in and show appropriate screen
        self.showSignIn()
    }
    
    func showSignIn() {
        let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        guard let chatsViewController = viewController as? ChatsViewController else { return }
        
        // Coordinator initializes and injects viewModel
        let chatsViewModel = ChatsViewModel()
        chatsViewController.viewModel = chatsViewModel
        
//        // Coordinator subscribes to events and decides when and how to navigate
//        signInViewModel.didSignIn
//            .subscribe(onNext: { [weak signInViewController] in
//                // Navigate to dashboard
//                signInViewController?.showAlert(title: "Success", message: "Signed in")
//            })
//            .disposed(by: self.disposeBag)
        
        self.navigationController.viewControllers = [chatsViewController]
    }
}
