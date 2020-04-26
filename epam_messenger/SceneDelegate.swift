//
//  SceneDelegate.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 08.03.2020.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Vars
    
    var window: UIWindow?
    let firestoreService = FirestoreService()

    // MARK: - Methods
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.backgroundColor = .systemBackground
        window?.windowScene = windowScene
        
        let navigationController = UINavigationController()
        navigationController.view.tintColor = .accent
        navigationController.hero.isEnabled = true // Just add that. We will explain that later.
        let assemblyBuilder = AssemblyBuilder()
        let router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
        
        router.initialViewController()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        if Auth.auth().currentUser != nil {
            firestoreService.offlineCurrentUser()
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {
        if Auth.auth().currentUser != nil {
            firestoreService.onlineCurrentUser()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        if Auth.auth().currentUser != nil {
            firestoreService.offlineCurrentUser()
        }
    }
}
