//
//  SettingsAssemblyBuilder.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 23.04.2020.
//
import UIKit

protocol SettingsAssemblyBuilder {
    func createSettingsStart(router: RouterProtocol) -> UIViewController
    func createUserSettingsEdit(router: RouterProtocol, userModel: UserModel) -> UIViewController
}

extension AssemblyBuilder: SettingsAssemblyBuilder {
    
    func createSettingsStart(router: RouterProtocol) -> UIViewController {
        let view = UserSettingsViewController()
        let viewModel = UserSettingsViewModel(
            router: router,
            viewController: view
        )
        view.viewModel = viewModel
        return view
    }
    
    func createUserSettingsEdit(router: RouterProtocol, userModel: UserModel) -> UIViewController {
        let view = UserInfoEditViewController()
        let viewModel = UserInfoEditViewModel(
            router: router,
            viewController: view,
            userModel: userModel
        )
        view.viewModel = viewModel
        return view
    }
}
