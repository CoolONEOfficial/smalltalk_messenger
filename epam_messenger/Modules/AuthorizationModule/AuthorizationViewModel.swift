//
//  AuthorizationViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import Foundation

protocol AuthorizationViewModelProtocol {
    func authorizeMe()
}

struct AuthorizationViewModel: AuthorizationViewModelProtocol {
    let router: RouterProtocol
    
    func authorizeMe() {
        router.showBottomBar()
    }
    
    init(router: RouterProtocol) {
        self.router = router
    }
}
