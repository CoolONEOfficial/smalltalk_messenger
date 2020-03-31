//
//  AuthEnterNameViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import UIKit

protocol AuthEnterNameViewControllerProtocol {
    
}

class AuthEnterNameViewController: UIViewController {
    var viewModel: AuthEnterNameViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AuthEnterNameViewController: AuthEnterNameViewControllerProtocol {
    
}
