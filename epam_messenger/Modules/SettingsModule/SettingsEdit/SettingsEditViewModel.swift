//
//  SettingsEditViewModel.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 23.04.2020.
//

import Foundation
import Firebase
import CodableFirebase
import SDWebImage

protocol SettingsEditViewModelProtocol: ViewModelProtocol {
    var userAvatar: UIImage? { get set }
    var userModel: UserModel { get set }

    func goToInitialView()
    func updateUser(completion: @escaping (Error?) -> Void)
}

class SettingsEditViewModel: SettingsEditViewModelProtocol {
    
    // MARK: - Vars
    
    var userAvatar: UIImage?
    var userModel: UserModel
    
    let router: RouterProtocol
    let viewController: SettingsEditViewControllerProtocol
    let firestoreService: FirestoreService
    let storageService: StorageServiceProtocol
    
    // MARK: - Init
    
    init(
        router: RouterProtocol,
        viewController: SettingsEditViewControllerProtocol,
        firestoreService: FirestoreService = FirestoreService(),
        userModel: UserModel,
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.router = router
        self.viewController = viewController
        self.firestoreService = firestoreService
        self.storageService = storageService
        self.userModel = userModel
    }
    
    func goToInitialView() {
        router.initialViewController()
    }
    
    func updateUser(completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let updateGroup = DispatchGroup()
        var err: Error?
        let avatarTimestamp = userAvatar != nil ? Date() : nil
        if let userAvatar = userAvatar {
            updateGroup.enter()
            storageService.uploadUserAvatar(
                userId: uid,
                avatar: userAvatar,
                timestamp: avatarTimestamp!
            ) { kind, avatarErr in
                if let avatarErr = avatarErr {
                    err = avatarErr
                }
                self.userModel.avatarPath = kind!.path
                updateGroup.leave()
            }
        }
        
        updateGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.firestoreService.updateUser(self.userModel) { chatErr in
                if let chatErr = chatErr {
                    err = chatErr
                }
                completion(err)
            }
        }
    }
}
