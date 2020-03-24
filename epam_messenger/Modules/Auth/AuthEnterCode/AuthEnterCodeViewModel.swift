//
//  AuthEnterCodeViewModel.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import Foundation
import FirebaseAuth

protocol AuthEnterCodeViewModelProtocol {
    func signIn(code: String)
}

struct AuthEnterCodeViewModel: AuthEnterCodeViewModelProtocol {
    let router: RouterProtocol
    let viewController: AuthEnterCodeViewControllerProtocol
    let verificationId: String
    let number: String
    
    func signIn(code: String) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                return
            }
            
//            if let additionalUserInfo = authResult?.additionalUserInfo {
//                if additionalUserInfo.isNewUser {
//                    if let router = self.router as? AuthRouter {
//                        router.showAuthEnterName()
//                    }
//                } else {
                    self.router.showChatList()
//                }
//            }
        }
    }
    
    init(router: RouterProtocol, viewController: AuthEnterCodeViewControllerProtocol, verificationId: String, number: String) {
        self.router = router
        self.viewController = viewController
        self.verificationId = verificationId
        self.number = number
    }
}
