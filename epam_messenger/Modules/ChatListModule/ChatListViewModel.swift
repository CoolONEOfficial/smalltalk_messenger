//
//  ChatListViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import Foundation
import Firebase
import InstantSearchClient
import CodableFirebase

protocol ChatListViewModelProtocol: ViewModelProtocol {
    func goToChat(_ chatModel: ChatModel)
    func firestoreQuery() -> FireQuery
    func searchChats(_ searchString: String, completion: @escaping AlgoliaService.SearchCompletion)
    func createChatPreview(_ chatModel: ChatModel) -> UIViewController
    func deleteChat(
        _ chatModel: ChatModel,
        completion: @escaping (Bool) -> Void
    )
}

extension ChatListViewModelProtocol {
    func deleteChat(
        _ chatModel: ChatModel,
        completion: @escaping (Bool) -> Void = {_ in}
    ) {
        deleteChat(chatModel, completion: completion)
    }
}

class ChatListViewModel: ChatListViewModelProtocol {
    let router: RouterProtocol
    let viewController: ChatListViewControllerProtocol
    let firestoreService: FirestoreService = .init()
    let algoliaService: AlgoliaService = .init()
    
    init(
        router: RouterProtocol,
        viewController: ChatListViewControllerProtocol
    ) {
        self.router = router
        self.viewController = viewController
    }
    
    func goToChat(_ chatModel: ChatModel) {
        router.showChat(chatModel)
    }
    
    func firestoreQuery() -> FireQuery {
        return firestoreService.chatListQuery
    }
    
    func searchChats(_ searchString: String, completion: @escaping AlgoliaService.SearchCompletion) {
        return algoliaService.searchChats(searchString, completion: completion)
    }
    
    func didChatLoad(snapshot: DocumentSnapshot, cell: ChatCell) {
        var data = snapshot.data() ?? [:]
        data["documentId"] = snapshot.documentID

//        do {
//            let chatModel = try FirestoreDecoder()
//                .decode(
//                    ChatModel.self,
//                    from: data
//            )
//        } catch {
//
//        }

        if let chatModel = ChatModel.fromSnapshot(snapshot) {

            cell.loadChatModel(chatModel)
        }
    }
    
    func createChatPreview(_ chatModel: ChatModel) -> UIViewController {
        return AssemblyBuilder().createChatModule(router: router, chatModel: chatModel)
    }
    
    func deleteChat(_ chatModel: ChatModel, completion: @escaping (Bool) -> Void = {_ in}) {
        firestoreService.deleteChat(
            chatDocumentId: chatModel.documentId,
            completion: completion
        )
    }
}
