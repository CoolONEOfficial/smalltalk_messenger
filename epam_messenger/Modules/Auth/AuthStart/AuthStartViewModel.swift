//
//  AuthStartViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import Foundation

protocol AuthStartViewModelProtocol {
    func startTalk()
}

struct AuthStartViewModel: AuthStartViewModelProtocol {
    let router: RouterProtocol
    let viewController: AuthStartViewControllerProtocol
    
    init(router: RouterProtocol, viewController: AuthStartViewControllerProtocol) {
        self.router = router
        self.viewController = viewController
    }
    
    func startTalk() {
        guard let router = router as? AuthRouter else { return }
        router.showAuthEnterNumber()
    }
}
