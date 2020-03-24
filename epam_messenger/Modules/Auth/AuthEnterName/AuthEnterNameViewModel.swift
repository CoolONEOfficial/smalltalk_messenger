//
//  AuthEnterNameViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import Foundation

protocol AuthEnterNameViewModelProtocol {
    
}

struct AuthEnterNameViewModel: AuthEnterNameViewModelProtocol {
    let router: RouterProtocol
    let viewController: AuthEnterNameViewControllerProtocol
    
    init(router: RouterProtocol, viewController: AuthEnterNameViewControllerProtocol) {
        self.router = router
        self.viewController = viewController
    }
}
