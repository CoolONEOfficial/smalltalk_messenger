//
//  AlgoliaService.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 20.03.2020.
//

import Foundation
import AlgoliaSearchClient
import FirebaseAuth
import AnyCodable

typealias AlgoliaQuery = Query
typealias SearchChatsCompletion = ([ChatModel]?) -> Void
typealias SearchMessagesCompletion = ([MessageModel]?) -> Void

protocol AlgoliaServiceProtocol: AutoMockable {
    func searchChats(_ searchString: String, completion: @escaping SearchChatsCompletion)
    func searchMessages(_ searchString: String, completion: @escaping SearchMessagesCompletion)
}

class AlgoliaService: AlgoliaServiceProtocol {
    
    // MARK: - Vars
    
    lazy var searchClient: SearchClient = {
        #if DEBUG
        return .init(
            appID: "0T6YXW26KA",
            apiKey: "b1c53722d5d6ed72d666ecfd14cb00a6"
        )
        #else
        return .init(
            appID: "V6J5G69XKH",
            apiKey: "c4ef45194a085992c251be8be124e796"
        )
        #endif
    }()
    
    lazy var chatsIndex: Index! = {
        return searchClient.index(withName: "chats")
    }()
    
    lazy var messagesIndex: Index! = {
        return searchClient.index(withName: "messages")
    }()
    
    lazy var usersIndex: Index! = {
        return searchClient.index(withName: "users")
    }()
    
    // MARK: - Functions
    
    func searchChats(_ searchString: String, completion: @escaping SearchChatsCompletion) {
        var query = Query()
        query.hitsPerPage = 20
        query.filters = "users:\(Auth.auth().currentUser!.uid)"
        query.query = searchString
        chatsIndex.search(query: query) { result in
            completion(self.parseContent(result))
        }
    }
    
    typealias SearchUsersCompletion = ([UserModel]?) -> Void
    func searchUsers(_ searchString: String, completion: @escaping SearchUsersCompletion) {
        var query = Query()
        query.hitsPerPage = 20
        query.query = searchString
        query.filters = "NOT objectID:\(Auth.auth().currentUser!.uid)"
        usersIndex.search(query: query) { result in
            completion(self.parseContent(result))
        }
    }
    
    func searchMessages(_ searchString: String, completion: @escaping SearchMessagesCompletion) {
        var query = Query()
        query.hitsPerPage = 20
        query.filters = "chatUsers:\(Auth.auth().currentUser!.uid)"
        query.query = searchString
        messagesIndex.search(query: query) { result in
            completion(self.parseContent(result))
        }
    }
    
    // MARK: - Helpers
    
    private func parseContent<T: Decodable>(_ result: Result<SearchResponse, Error>) -> [T]? {
        switch result {
        case let .success(content):
            guard let chats: [[String: AnyCodable]] = try? content.extractHits() else { return nil }
            
            return chats.map { record in
                var model = record
                model["documentId"] = record["objectID"]
                return try? JSONDecoder().decode(T.self, from: JSONSerialization.data(withJSONObject: model))
            }.compactMap {$0}
            
        case let .failure(error):
            print(error.localizedDescription)
            return nil
        }
    }
}
