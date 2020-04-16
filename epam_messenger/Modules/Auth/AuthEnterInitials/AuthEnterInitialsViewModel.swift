//
//  AuthEnterNameViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import UIKit
import Foundation
import ContactsUI
import FirebaseAuth
import PhoneNumberKit

protocol AuthEnterInitialsViewModelProtocol {
    func createUser(
        userModel: UserModel,
        avatar: UIImage?,
        progressAddiction: @escaping (Float) -> Void,
        completion: @escaping (Error?) -> Void
    )
}

class AuthEnterInitialsViewModel: AuthEnterInitialsViewModelProtocol {
    
    // MARK: - Vars
    
    let router: RouterProtocol
    let viewController: AuthEnterInitialsViewControllerProtocol
    
    let firestoreService: FirestoreServiceProtocol
    let storageService: StorageServiceProtocol
    
    // MARK: - Init
    
    init(
        router: RouterProtocol,
        viewController: AuthEnterInitialsViewControllerProtocol,
        firestoreService: FirestoreServiceProtocol = FirestoreService(),
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.router = router
        self.viewController = viewController
        self.firestoreService = firestoreService
        self.storageService = storageService
    }
    
    // MARK: - Methods
    
    func createUser(
        userModel: UserModel,
        avatar: UIImage?,
        progressAddiction: @escaping (Float) -> Void,
        completion: @escaping (Error?) -> Void
    ) {
        let createGroup = DispatchGroup()
        
        var err: Error? = nil
        var steps: Float = 0
        
        steps += 1
        createGroup.enter()
        let userId = firestoreService.createUser(userModel) { error in
            if error != nil {
                err = error
            }
            progressAddiction(1 / steps)
            createGroup.leave()
            debugPrint("user leave")
        }
        
        if let avatar = avatar {
            steps += 1
            createGroup.enter()
            storageService.uploadUserAvatar(userId: userId, avatar: avatar) { error in
                if error != nil {
                    err = error
                }
                progressAddiction(1 / steps)
                createGroup.leave()
            }
        }
        
        steps += 1
        createGroup.enter()
        let allContacts = getContacts()
        firestoreService.searchUsers(
            by: allContacts
        ) { [weak self] contactList, last in
            guard let self = self else { return }
            
            if let contactList = contactList {
                
                let chatsGroup = DispatchGroup()
               
                for contact in contactList {
                    chatsGroup.enter()
                    self.firestoreService.createChat(
                        .init(
                            documentId: nil,
                            users: [
                                Auth.auth().currentUser!.uid,
                                contact.documentId!
                            ],
                            lastMessage: .empty(),
                            type: .personalCorr
                    )) { error in
                        if error != nil {
                            err = error
                        }
                        chatsGroup.leave()
                    }
                    
                    chatsGroup.enter()
                    self.firestoreService.createContact(.init(
                        localName: contact.fullName,
                        userId: contact.documentId!)
                    ) { error in
                        if error != nil {
                            err = error
                        }
                        chatsGroup.leave()
                    }
                }
                
                chatsGroup.notify(queue: .main) {
                    if last {
                        progressAddiction(1 / steps)
                        createGroup.leave()
                    }
                }
            }
        }
        
        steps += 1
        createGroup.enter()
        self.firestoreService.createChat(
            .init(
                documentId: nil,
                users: [
                    Auth.auth().currentUser!.uid
                ],
                lastMessage: .empty(),
                type: .personalCorr
        )) { chatErr in
            if chatErr != nil {
                err = chatErr
            }
            progressAddiction(1 / steps)
            createGroup.leave()
        }
        
        createGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            completion(err)
            self.router.showBottomBar()
        }
    }
    
    private func getContacts() -> [String] {
        let contactStore = CNContactStore()
        var contacts = [String]()
        let keys = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                        CNContactPhoneNumbersKey
                ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request) { (contact, _) in
                let validTypes = [
                    CNLabelPhoneNumberiPhone,
                    CNLabelPhoneNumberMobile,
                    CNLabelPhoneNumberMain
                ]

                let numbers = contact.phoneNumbers.compactMap { phoneNumber -> String? in
                    guard let label = phoneNumber.label, validTypes.contains(label) else { return nil }
                    return phoneNumber.value.stringValue
                }
                
                contacts.append(contentsOf: numbers)
            }
        } catch {
            print("unable to fetch contacts")
        }
        
        let phoneNumberKit = PhoneNumberKit()
        let currentPhoneNumber = Auth.auth().currentUser!.phoneNumber
        let parsed = phoneNumberKit.parse(contacts, shouldReturnFailedEmptyNumbers: true)
            .filter({ !$0.notParsed() })
            .map({ phoneNumberKit.format($0, toType: .e164) })
            .filter({ $0 != currentPhoneNumber })
            .unique()
        
        return parsed
    }
}
