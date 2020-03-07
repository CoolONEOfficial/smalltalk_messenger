//
//  ChatViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 08.03.2020.
//

import Foundation

protocol ChatViewModelProtocol {
    
}

struct ChatViewModel: ChatViewModelProtocol {
    let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
}
