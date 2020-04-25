//
//  SettingsRouter.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 23.04.2020.
//

import UIKit

protocol SettingsRouter {
    func showSettingsStart()
    func showUserInfoEdit(_ userModel: UserModel)
}

extension Router: SettingsRouter {
    func showSettingsStart() {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder = assemblyBuilder as? SettingsAssemblyBuilder else { return }
        let settingsStartViewController = assemblyBuilder.createSettingsStart(
            router: self)
        navigationController.viewControllers = [settingsStartViewController]
    }
    
    func showUserInfoEdit(_ userModel: UserModel) {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder = assemblyBuilder as? SettingsAssemblyBuilder else { return }
        let userInfoEditViewController = assemblyBuilder.createUserSettingsEdit(
            router: self,
            userModel: userModel
            )
        navigationController.pushViewController(userInfoEditViewController, animated: false)
    }
}
