//
//  SettingsAssemblyBuilder.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 23.04.2020.
//
import UIKit

protocol SettingsAssemblyBuilder {
    func createSettingsStart(router: RouterProtocol) -> UIViewController
    func createSettingsStartEdit(router: RouterProtocol, userModel: UserModel) -> UIViewController
}

extension AssemblyBuilder: SettingsAssemblyBuilder {
    
    func createSettingsStart(router: RouterProtocol) -> UIViewController {
        let view = SettingsStartViewController()
        let viewModel = SettingsStartViewModel(
            router: router,
            viewController: view
        )
        view.viewModel = viewModel
        return view
    }
    
    func createSettingsStartEdit(router: RouterProtocol, userModel: UserModel) -> UIViewController {
        let view = SettingsEditViewController()
        let viewModel = SettingsEditViewModel(
            router: router,
            viewController: view,
            userModel: userModel
        )
        view.viewModel = viewModel
        return view
    }
}
