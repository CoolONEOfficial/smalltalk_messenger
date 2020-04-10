//
//  ChatDetailsViewModel.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 09.04.2020.
//

import Foundation

protocol ChatDetailsViewModelProtocol {
    var chat: ChatProtocol { get }
}

class ChatDetailsViewModel: ChatDetailsViewModelProtocol {
    
    // MARK: - Vars
    
    let router: RouterProtocol
    let viewController: ChatDetailsViewControllerProtocol
    let firestoreService: FirestoreServiceProtocol
    
    let chat: ChatProtocol
    
    // MARK: - Init
    
    init(
        router: RouterProtocol,
        viewController: ChatDetailsViewControllerProtocol,
        chat: ChatProtocol,
        firestoreService: FirestoreServiceProtocol = FirestoreService()
    ) {
        self.router = router
        self.viewController = viewController
        self.chat = chat
        self.firestoreService = firestoreService
    }
}
