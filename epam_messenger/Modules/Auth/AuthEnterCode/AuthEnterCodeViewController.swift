//
//  AuthEnterCodeViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import UIKit

protocol AuthEnterCodeViewControllerProtocol {
    
}

class AuthEnterCodeViewController: UIViewController {
    var viewModel: AuthEnterCodeViewModelProtocol!
  
    @IBOutlet weak var codeTextField: AuthEnterCodeTextField!
    
    @objc func touchNext() {
        guard let code = codeTextField.text else { return }
        viewModel.signIn(code: code)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.systemBackground
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        let nextButton = UIButton(type: .custom)
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(UIColor.systemIndigo, for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        nextButton.addTarget(nil, action: #selector(touchNext), for: .touchUpInside)
        let next = UIBarButtonItem(customView: nextButton)
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = next
        
        codeTextField.becomeFirstResponder()
        codeTextField.configure()
        codeTextField.didEnterLastDigit = { [weak self] code in
            guard let self = self else { return }
            self.viewModel.signIn(code: code)
        }
    }
    
    override func viewDidLayoutSubviews() {
        let borderTop = CALayer()
        borderTop.frame = CGRect(x: -16, y: 0, width: codeTextField.frame.width + 32, height: 0.75)
        borderTop.backgroundColor = UIColor.systemGray2.cgColor

        let borderBottom = CALayer()
        borderBottom.frame = CGRect(x: -16, y: codeTextField.frame.height - 0.75, width: codeTextField.frame.width + 32, height: 0.75)
        borderBottom.backgroundColor = UIColor.systemGray2.cgColor
        
        codeTextField.layer.addSublayer(borderTop)
        codeTextField.layer.addSublayer(borderBottom)
    }
}

extension AuthEnterCodeViewController: AuthEnterCodeViewControllerProtocol {
    
}
