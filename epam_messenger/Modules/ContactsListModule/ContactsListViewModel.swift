//
//  ContactsListViewModel.swift
//  epam_messenger
//
//  Created by Maxim on 13.03.2020.
//

import Foundation
import Firebase
import CodableFirebase

protocol ContactsListViewModelProtocol: ViewModelProtocol {
    //func goToContacts() // понадобится для отображения конкретного контакта
    func firestoreQuery() -> Query
    func didContactLoad(snapshot: DocumentSnapshot, cell: ContactsCell)
}

class ContactsListViewModel: ContactsListViewModelProtocol {
    
    let router: RouterProtocol
    let viewController: ContactsListViewControllerProtocol
    let firestoreService: FirestoreService = FirestoreService()
    
    init(
        router: RouterProtocol,
        viewController: ContactsListViewControllerProtocol
    ) {
        self.router = router
        self.viewController = viewController
    }
    
    func firestoreQuery() -> Query {
        return firestoreService.contactsListQuery
    }
    
    //    func goToProfile() {
    //        router.showContactsList()
    //    }
    
    func didContactLoad(snapshot: DocumentSnapshot, cell: ContactsCell) {
        if let user = UserModel.fromSnapshot(snapshot)
        {
            cell.loadUserModel(user)
        }
    }
}
