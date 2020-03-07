//
//  ChatListViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import Foundation

protocol ChatListViewModelProtocol {
    func goToChat()
}

struct ChatListViewModel: ChatListViewModelProtocol {
    let router: RouterProtocol
    
    func goToChat() {
        router.showChat()
    }
    
    init(router: RouterProtocol) {
        self.router = router
    }
}
