//
//  AppDelegate.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 05.03.2020.
//  Copyright © 2020 Nickolay Truhin. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let appCoordinator = AppCoordinator()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        self.appCoordinator.start()
        return true
    }
}
