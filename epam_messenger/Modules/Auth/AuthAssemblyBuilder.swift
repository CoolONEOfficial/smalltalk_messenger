//
//  AuthAssemblyBuilder.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import UIKit

protocol AuthAssemblyBuilder {
    func createAuthStart(router: RouterProtocol) -> UIViewController
    func createAuthEnterNumber(router: RouterProtocol) -> UIViewController
    func createAuthEnterCode(router: RouterProtocol, verificationId: String, number: String) -> UIViewController
    func createAuthEnterName(router: RouterProtocol) -> UIViewController
}

extension AssemblyBuilder: AuthAssemblyBuilder {
    func createAuthStart(router: RouterProtocol) -> UIViewController {
        let view = AuthStartViewController()
        let viewModel = AuthStartViewModel(router: router, viewController: view)
        view.viewModel = viewModel
        return view
    }
    
    func createAuthEnterNumber(router: RouterProtocol) -> UIViewController {
        let view = AuthEnterNumberViewController()
        let viewModel = AuthEnterNumberViewModel(router: router, viewController: view)
        view.viewModel = viewModel
        return view
    }
    
    func createAuthEnterCode(router: RouterProtocol, verificationId: String, number: String) -> UIViewController {
        let view = AuthEnterCodeViewController()
        let viewModel = AuthEnterCodeViewModel(router: router, viewController: view, verificationId: verificationId, number: number)
        view.viewModel = viewModel
        return view
    }
    
    func createAuthEnterName(router: RouterProtocol) -> UIViewController {
        let view = AuthEnterNameViewController()
        let viewModel = AuthEnterNameViewModel(router: router, viewController: view)
        view.viewModel = viewModel
        return view
    }
}
