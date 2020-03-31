//
//  AuthRouter.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import UIKit

protocol AuthRouter {
    func showAuthStart()
    func showAuthEnterNumber()
    func showAuthEnterCode(verificationId: String, number: String)
    func showAuthEnterName()
}

extension Router: AuthRouter {
    func showAuthStart() {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder = assemblyBuilder as? AuthAssemblyBuilder else { return }
        let authStartViewController = assemblyBuilder.createAuthStart(router: self)
        navigationController.viewControllers = [authStartViewController]
    }
    
    func showAuthEnterNumber() {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder = assemblyBuilder as? AuthAssemblyBuilder else { return }
        let authEnterNumberViewController = assemblyBuilder.createAuthEnterNumber(router: self)
        navigationController.pushViewController(authEnterNumberViewController, animated: true)
    }
    
    func showAuthEnterCode(verificationId: String, number: String) {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder = assemblyBuilder as? AuthAssemblyBuilder else { return }
        let authEnterCodeViewController = assemblyBuilder.createAuthEnterCode(router: self, verificationId: verificationId, number: number)
        navigationController.pushViewController(authEnterCodeViewController, animated: true)
    }
    
    func showAuthEnterName() {
        guard let navigationController = navigationController else { return }
        guard let assemblyBuilder = assemblyBuilder as? AuthAssemblyBuilder else { return }
        let authEnterNameViewController = assemblyBuilder.createAuthEnterName(router: self)
        navigationController.pushViewController(authEnterNameViewController, animated: true)
    }
}
