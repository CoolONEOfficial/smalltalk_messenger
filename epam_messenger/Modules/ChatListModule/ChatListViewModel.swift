//
//  ChatListViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import Foundation
import Firebase

protocol ChatListViewModelProtocol: ViewModelProtocol {
    func goToChat()
    func chatList() -> [ChatModel]
}

class ChatListViewModel: ChatListViewModelProtocol {
    let router: RouterProtocol
    let viewController: ChatListViewControllerProtocol
    let firestoreService: FirestoreService = FirestoreService()
    
    var data: [ChatModel] = [] {
        didSet {
            viewController.performUpdates()
        }
    }
    
    init(
        router: RouterProtocol,
        viewController: ChatListViewControllerProtocol
    ) {
        self.router = router
        self.viewController = viewController
    }
    
    func goToChat() {
        router.showChat()
    }
    
    func chatList() -> [ChatModel] {
        return data
    }
    
    func viewDidLoad() {
        firestoreService.loadChatList(
            chatListListener: { parsedData in
                self.data = parsedData
            },
            lastMessageListener: { message, index in
                self.data[index].lastMessage = message
                self.viewController.reloadCell(self.data[index])
            }
        )
    }
}
