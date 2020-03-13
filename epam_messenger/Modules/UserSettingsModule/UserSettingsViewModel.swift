//
//  UserSettingsViewModel.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 12.03.2020.
//

import Foundation

protocol UserSettingsViewModelProtocol {
    //func authorizeMe()
}

struct UserSettingsViewModel: UserSettingsViewModelProtocol {
    let router: RouterProtocol
    
//    func authorizeMe() {
//        router.showBottomBar()
//    }
    
    init(router: RouterProtocol) {
        self.router = router
    }
}
