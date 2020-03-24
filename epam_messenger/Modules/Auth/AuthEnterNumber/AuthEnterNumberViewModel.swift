//
//  AuthEnterNumberViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import Foundation
import FirebaseAuth

protocol AuthEnterNumberViewModelProtocol {
    func verifyNumber(number: String)
}

struct AuthEnterNumberViewModel: AuthEnterNumberViewModelProtocol {
    let router: RouterProtocol
    let viewController: AuthEnterNumberViewControllerProtocol
    
    func verifyNumber(number: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (verificationId, error) in
            guard let verificationId = verificationId else { return }
            
            if error != nil {
                return
            }
            
            guard let router = self.router as? AuthRouter else { return }
            router.showAuthEnterCode(verificationId: verificationId, number: number)
        }
    }
    
    init(router: RouterProtocol, viewController: AuthEnterNumberViewControllerProtocol) {
        self.router = router
        self.viewController = viewController
    }
}
