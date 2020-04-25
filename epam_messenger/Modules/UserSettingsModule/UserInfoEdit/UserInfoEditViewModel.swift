//
//  UserInfoEditViewModel.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 23.04.2020.
//

import Foundation
import Firebase
import CodableFirebase
import SDWebImage

protocol UserInfoEditViewModelProtocol: ViewModelProtocol {
    
    var userAvatar: UIImage? { get set }
    var userModel: UserModel { get set }
    var userColor: UIColor? { get set }
    
    func goToInitialView()
    func updateUser(completion: @escaping (Error?) -> Void)
}

class UserInfoEditViewModel: UserInfoEditViewModelProtocol {
    
    var userAvatar: UIImage?
    var userModel: UserModel
    var userColor: UIColor?
    
    let router: RouterProtocol
    let viewController: UserInfoEditViewControllerProtocol
    let firestoreService: FirestoreService
    let storageService: StorageServiceProtocol
    
    init(
        router: RouterProtocol,
        viewController: UserInfoEditViewControllerProtocol,
        firestoreService: FirestoreService = FirestoreService(),
        userModel: UserModel,
        storageService: StorageServiceProtocol = StorageService()
    ) {
        self.router = router
        self.viewController = viewController
        self.firestoreService = firestoreService
        self.userModel = userModel
        self.storageService = storageService
    }
    
    func goToInitialView() {
        router.initialViewController()
    }
    
    func updateUser(completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let updateGroup = DispatchGroup()
        var err: Error?
        let avatarTimestamp = userAvatar != nil ? Date() : nil
        userModel.color = userColor ?? .accent
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
