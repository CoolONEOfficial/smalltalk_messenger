//
//  UserSettingsViewModel.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 03.04.2020.
//
import Foundation
import Firebase
import CodableFirebase

protocol UserSettingsViewModelProtocol: ViewModelProtocol {
    
    var userModel: UserModel! { get set }
    
    func currentUserData(completion: @escaping (UserModel?) -> Void)
    func showUserInfoEdit()
    
}

class UserSettingsViewModel: UserSettingsViewModelProtocol {
    
    var userModel: UserModel! {
        didSet {
            viewController.userDidUpdate()
        }
    }
        
    let router: RouterProtocol
    let viewController: UserSettingsViewControllerProtocol
    let firestoreService: FirestoreService   
    let algoliaService: AlgoliaService
    
    init(
        router: RouterProtocol,
        viewController: UserSettingsViewControllerProtocol,
        firestoreService: FirestoreService = FirestoreService(),
        algoliaService: AlgoliaService = AlgoliaService()
    ) {
        self.router = router
        self.viewController = viewController
        self.firestoreService = firestoreService
        self.algoliaService = algoliaService
    }
    
    func viewDidLoad() {
        firestoreService.listenUserData(Auth.auth().currentUser!.uid){ userModel in
            if let userModel = userModel {
                self.userModel = userModel
            }
        }
    }
    
    func currentUserData(
        completion: @escaping (UserModel?) -> Void
    ) {
        firestoreService.listenCurrentUserData(completion: completion)
    }
    
    func goToInitialView() {
        router.initialViewController()
    }
    
    func showUserInfoEdit() {
        guard let router = router as? SettingsRouter else { return }
        router.showUserInfoEdit(userModel)
    }
}
