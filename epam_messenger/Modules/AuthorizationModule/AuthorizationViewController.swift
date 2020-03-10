//
//  AuthorizationViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import UIKit

class AuthorizationViewController: UIViewController {
    var viewModel: AuthorizationViewModelProtocol!
    
    @IBAction func touchAuthorizeMe() {
        viewModel.authorizeMe()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Authorization"
    }
}
