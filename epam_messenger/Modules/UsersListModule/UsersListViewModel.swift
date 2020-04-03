//
//  ContactsListViewModel.swift
//  epam_messenger
//
//  Created by Maxim on 13.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

protocol UsersListViewModelProtocol: ViewModelProtocol {
    //func goToContacts() // понадобится для отображения конкретного контакта
    func firestoreQuery() -> Query
    func didUsersListLoad(snapshot: DocumentSnapshot, cell: UsersListCell)
}

class UsersListViewModel: UsersListViewModelProtocol {
    
    let router: RouterProtocol
    let viewController: UsersListViewControllerProtocol
    let firestoreService: FirestoreService = FirestoreService()
    
    init(
        router: RouterProtocol,
        viewController: UsersListViewControllerProtocol
    ) {
        self.router = router
        self.viewController = viewController
    }
    
    func firestoreQuery() -> Query {
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
}
