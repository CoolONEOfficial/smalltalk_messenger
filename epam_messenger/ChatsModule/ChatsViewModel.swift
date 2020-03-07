//
//  ChatsViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import Foundation

protocol ChatsViewModelProtocol {
    func goToChat()
}

struct ChatsViewModel: ChatsViewModelProtocol {
    let router: RouterProtocol
    
    func goToChat() {
        router.showChat()
    }
    
    init(router: RouterProtocol) {
        self.router = router
    }
}
