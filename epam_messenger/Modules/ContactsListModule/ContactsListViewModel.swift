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
    //func goToContacts() // понадобится для отображения конкретного контакта
    func firestoreContactsListQuery() -> Query
    func didContactsListLoad(snapshot: DocumentSnapshot, cell: ContactsListCell)
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
    
    func firestoreContactsListQuery() -> Query {
        return firestoreService.contactsListQuery
    }
    
    //    func goToProfile() {
    //        router.showContactsList()
    //    }
    
    func didContactsListLoad(snapshot: DocumentSnapshot, cell: ContactsListCell) {
        if let contactsList = ContactsListModel.fromSnapshot(snapshot)
        {
            cell.loadContactsListModel(contactsList)
        }
    }
}
