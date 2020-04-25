//
//  UserContactsListViewModel.swift
//  epam_messenger
//
//  Created by Maxim on 25.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

protocol ContactsListViewModelProtocol: ViewModelProtocol {
    func didContactSelect(_ contact: ContactModel)
    func didUserSelect(_ user: UserModel)
    func deleteContact(_ contactId: String, completion: @escaping (Error?) -> Void)
    func searchUsers(_ searchString: String, completion: @escaping AlgoliaService.SearchUsersCompletion)
    var baseQuery: FireQuery { get }
}

class ContactsListViewModel: ContactsListViewModelProtocol {
    
    let router: RouterProtocol
    let viewController: ContactsListViewControllerProtocol
    let firestoreService: FirestoreService
    let algoliaService: AlgoliaService = .init()
    
    init(
        router: RouterProtocol,
        viewController: ContactsListViewControllerProtocol,
        firestoreService: FirestoreService = FirestoreService()
    ) {
        self.router = router
        self.viewController = viewController
        self.firestoreService = firestoreService
    }
    
    var baseQuery: FireQuery {
        return firestoreService.contactListQuery
    }
    
    func didContactSelect(_ contact: ContactModel) {
        guard let router = self.router as? ChatRouter else { return }
        router.showChat(userId: contact.userId)
    }
    
    func didUserSelect(_ user: UserModel) {
        guard let router = self.router as? ChatRouter else { return }
        router.showChat(userId: user.documentId!)
    }
    
    func searchUsers(_ searchString: String, completion: @escaping AlgoliaService.SearchUsersCompletion) {
        algoliaService.searchUsers(searchString, completion: completion)
    }
    
    func deleteContact(_ contactId: String, completion: @escaping (Error?) -> Void) {
        firestoreService.deleteContact(contactId, completion: completion)
    }
}
