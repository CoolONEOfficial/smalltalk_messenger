//
//  AlgoliaService.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 20.03.2020.
//

import Foundation
import InstantSearchClient
import FirebaseAuth

typealias AlgoliaQuery = Query

class AlgoliaService {
    
    // MARK: - Vars
    
    lazy var searchClient: Client = {
        return Client(appID: "V6J5G69XKH", apiKey: "c4ef45194a085992c251be8be124e796")
    }()
    
    lazy var chatsIndex: Index! = {
        return searchClient.index(withName: "chats")
    }()
    
    lazy var usersIndex: Index! = {
        return searchClient.index(withName: "users")
    }()
    
    // MARK: - Functions
    
    typealias SearchCompletion = ([ChatModel]?) -> Void
    func searchChats(_ searchString: String, completion: @escaping SearchCompletion) {
        let query = Query()
        query.hitsPerPage = 20
        query.filters = "users = \(Auth.auth().currentUser!.uid)"
        query.query = searchString
        chatsIndex.search(query) { (content, error) in
            completion(self.parseContent(content: content, error: error))
        }
    }
    
    typealias SearchUsersCompletion = ([UserModel]?) -> Void
    func searchChats(_ searchString: String, completion: @escaping SearchUsersCompletion) {
        let query = Query()
        query.hitsPerPage = 20
        query.query = searchString
        usersIndex.search(query) { (content, error) in
            completion(self.parseContent(content: content, error: error))
        }
    }
    
    // MARK: - Helpers
    
    private func parseContent<T: Decodable>(content: [String: Any]?, error: Error?) -> [T]? {
        guard let content = content else {
            if let error = error {
                print(error.localizedDescription)
            }
            return nil
        }
        
        guard let chats = content["hits"] as? [[String: Any]] else { return nil }
        
        return chats.map { record in
            var model = record
            model["documentId"] = record["objectID"]
            return try! JSONDecoder().decode(T.self, from: JSONSerialization.data(withJSONObject: model))
        }
    }
}
