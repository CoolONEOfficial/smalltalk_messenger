//
//  UserContactsListViewModel.swift
//  epam_messenger
//
//  Created by Maxim on 25.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

protocol UserContactsListViewModelProtocol: ViewModelProtocol {
    //func goToContacts() // понадобится для отображения конкретного контакта
    func firestoreUserContactsListQuery() -> Query
    func didUserContactsListLoad(snapshot: DocumentSnapshot, cell: UserContactsListCell)
}

class UserContactsListViewModel: UserContactsListViewModelProtocol {
    
    let router: RouterProtocol
    let viewController: UserContactsListViewControllerProtocol
    let firestoreService: FirestoreService = FirestoreService()
    
    init(
        router: RouterProtocol,
        viewController: UserContactsListViewControllerProtocol
    ) {
        self.router = router
        self.viewController = viewController
    }
    
    func firestoreUserContactsListQuery() -> Query {
        return firestoreService.userContactsListQuery
    }
    
    //    func goToProfile() {
    //        router.showContactsList()
    //    }
    
    func didUserContactsListLoad(snapshot: DocumentSnapshot, cell: UserContactsListCell) {
        if let contactsList = UserContactsListModel.fromSnapshot(snapshot)
        {
            cell.loadUserContactsListModel(contactsList)
        }
    }
}
