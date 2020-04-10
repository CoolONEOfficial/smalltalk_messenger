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
    func didContactsListLoad(snapshot: DocumentSnapshot, cell: ContactCell)
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
    
    func didContactsListLoad(snapshot: DocumentSnapshot, cell: ContactCell) {
        if let contact = ContactModel.fromSnapshot(snapshot) {
            cell.loadContact(contact)
        }
    }
    
    func searchUsers(_ searchString: String, completion: @escaping AlgoliaService.SearchUsersCompletion) {
        return algoliaService.searchUsers(searchString, completion: completion)
    }
    
}
