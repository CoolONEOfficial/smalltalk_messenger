//
//  ChatsViewController.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 05.03.2020.
//  Copyright © 2020 Nickolay Truhin. All rights reserved.
//

import Foundation
import UIKit

class ChatsViewController: UIViewController {
//
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var signInButton: UIButton!
//
//    private let disposeBag = DisposeBag()
    var viewModel: ChatsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    private func setUpBindings() {
//        guard let viewModel = viewModel else { return }
//
//        self.emailTextField.rx.text.orEmpty
//            .bind(to: viewModel.emailAddress)
//            .disposed(by: self.disposeBag)
//
//        self.passwordTextField.rx.text.orEmpty
//            .bind(to: viewModel.password)
//            .disposed(by: self.disposeBag)
//
//        self.signInButton.rx.tap
//            .bind { viewModel.signInTapped() }
//            .disposed(by: self.disposeBag)
//
//        viewModel.isSignInActive
//            .bind(to: self.signInButton.rx.isEnabled)
//            .disposed(by: self.disposeBag)
//
//        viewModel.didFailSignIn
//            .subscribe(onNext: { error in
//                print("Failed: \(error)")
//            })
//            .disposed(by: self.disposeBag)
//    }
}
