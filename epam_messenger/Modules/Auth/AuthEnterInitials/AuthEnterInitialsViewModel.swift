//
//  AuthEnterNameViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import UIKit

protocol AuthEnterInitialsViewModelProtocol {
    func createUser(
        userModel: UserModel,
        avatar: UIImage?
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
        avatar: UIImage?
    ) {
        let createGroup = DispatchGroup()
        
        var err = false
        
        createGroup.enter()
        let userId = firestoreService.createUser(userModel) { result in
            if !result {
                err = true
            }
            createGroup.leave()
        }
        
        if let avatar = avatar {
            createGroup.enter()
            storageService.uploadUserAvatar(userId: userId, avatar: avatar) { result in
                if !result {
                    err = true
                }
                createGroup.leave()
            }
        }
        
        createGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if err {
                self.viewController.presentErrorAlert("Something went wrong")
            } else {
                self.router.showBottomBar()
            }
        }
    }
}
