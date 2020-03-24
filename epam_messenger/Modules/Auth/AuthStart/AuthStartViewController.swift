//
//  AuthStartViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import UIKit

protocol AuthStartViewControllerProtocol {
    
}

class AuthStartViewController: UIViewController {
    var viewModel: AuthStartViewModelProtocol!

    @IBAction func touchStartTalk() {
        viewModel.startTalk()
    }
    
    @IBOutlet weak var buttonStartTalk: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonStartTalk.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
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

extension AuthStartViewController: AuthStartViewControllerProtocol {
    
}
