//
//  ContactsListViewModel.swift
//  epam_messenger
//
//  Created by Maxim on 13.03.2020.
//

import Foundation
import Firebase
import CodableFirebase
import InstantSearchClient

protocol UsersListViewModelProtocol: ViewModelProtocol {
    //func goToContacts() // понадобится для отображения конкретного контакта
    func firestoreQuery() -> FireQuery
    func didUsersListLoad(snapshot: DocumentSnapshot, cell: UsersListCell)
    func searchUsers(_ searchString: String, completion: @escaping AlgoliaService.SearchUsersCompletion)
}

class UsersListViewModel: UsersListViewModelProtocol {
    
    let router: RouterProtocol
    let viewController: UsersListViewControllerProtocol
    let firestoreService: FirestoreService = FirestoreService()
    let algoliaService: AlgoliaService = .init()
    
    init(
        router: RouterProtocol,
        viewController: UsersListViewControllerProtocol
    ) {
        self.router = router
        self.viewController = viewController
    }
    
    func firestoreQuery() -> FireQuery {
        return firestoreService.usersListQuery
    }
    
    //    func goToProfile() {
    //        router.showContactsList()
    //    }
    
    func didUsersListLoad(snapshot: DocumentSnapshot, cell: UsersListCell) {
        if let user = UserModel.fromSnapshot(snapshot)
        {
            cell.loadUserModel(user)
        }
    }
    
    func searchUsers(_ searchString: String, completion: @escaping AlgoliaService.SearchUsersCompletion) {
        return algoliaService.searchUsers(searchString, completion: completion)
    }
    
}
