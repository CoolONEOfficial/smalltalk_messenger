//
//  AuthEnterNumberViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import UIKit

protocol AuthEnterNumberViewControllerProtocol {
    
}

class AuthEnterNumberViewController: UIViewController {
    var viewModel: AuthEnterNumberViewModelProtocol!
    
    @IBOutlet weak var numberTextField: UITextField!
    
    @objc func touchNext() {
        guard let number = numberTextField.text else { return }
        viewModel.verifyNumber(number: number)
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
        
        numberTextField.becomeFirstResponder()
        numberTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        let borderTop = CALayer()
        borderTop.frame = CGRect(x: -16, y: 0, width: numberTextField.frame.width + 32, height: 0.75)
        borderTop.backgroundColor = UIColor.systemGray2.cgColor

        let borderBottom = CALayer()
        borderBottom.frame = CGRect(x: -16, y: numberTextField.frame.height - 0.75, width: numberTextField.frame.width + 32, height: 0.75)
        borderBottom.backgroundColor = UIColor.systemGray2.cgColor
        
        numberTextField.layer.addSublayer(borderTop)
        numberTextField.layer.addSublayer(borderBottom)
    }
}

extension AuthEnterNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "+1234567890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
}

extension AuthEnterNumberViewController: AuthEnterNumberViewControllerProtocol {

}
