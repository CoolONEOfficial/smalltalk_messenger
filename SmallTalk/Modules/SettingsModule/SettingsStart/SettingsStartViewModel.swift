//
//  SettingsStartViewModel.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 03.04.2020.
//
import Foundation
import Firebase
import CodableFirebase

protocol SettingsStartViewModelProtocol: ViewModelProtocol {
    
    var userModel: UserModel! { get set }
    
    func currentUserData(completion: @escaping (UserModel?) -> Void)
    func showSettingsEdit()
    
}

class SettingsStartViewModel: SettingsStartViewModelProtocol {
    
    var userModel: UserModel! {
        didSet {
            viewController.userDidUpdate()
        }
    }
    
    let router: RouterProtocol
    let viewController: SettingsStartViewControllerProtocol
    let firestoreService: FirestoreService   
    let algoliaService: AlgoliaService
    
    init(
        router: RouterProtocol,
        viewController: SettingsStartViewControllerProtocol,
        firestoreService: FirestoreService = FirestoreService(),
        algoliaService: AlgoliaService = AlgoliaService()
    ) {
        self.router = router
        self.viewController = viewController
        self.firestoreService = firestoreService
        self.algoliaService = algoliaService
    }
    
    func viewDidLoad() {
        firestoreService.listenUserData(
            Auth.auth().currentUser!.uid
        ) { userModel in
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
    
    func showSettingsEdit() {
        guard let router = router as? SettingsRouter else { return }
        router.showSettingsEdit(userModel)
    }
}
