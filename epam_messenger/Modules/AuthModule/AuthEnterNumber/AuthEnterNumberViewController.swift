//
//  AuthEnterNumberViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import UIKit
import PhoneNumberKit

protocol AuthEnterNumberViewControllerProtocol {
    func showErrorAlert(_ text: String)
}

class AuthEnterNumberViewController: UIViewController {
    var viewModel: AuthEnterNumberViewModelProtocol!
    
    @IBOutlet weak var numberTextField: AuthPhoneNumberTextField!
    
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
        
        numberTextField.withFlag = true
        numberTextField.withPrefix = true
        numberTextField.delegate = self
        
        numberTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        let padding = numberTextField.frame.minX
        
        let borderTop = CALayer()
        borderTop.frame = CGRect(
            x: -padding,
            y: 0,
            width: numberTextField.frame.width + padding * 2,
            height: 0.75
        )
        borderTop.backgroundColor = UIColor.systemGray2.cgColor

        let borderBottom = CALayer()
        borderBottom.frame = CGRect(
            x: -padding,
            y: numberTextField.frame.height - 0.75,
            width: numberTextField.frame.width + padding * 2,
            height: 0.75
        )
        borderBottom.backgroundColor = UIColor.systemGray2.cgColor
        
        numberTextField.layer.addSublayer(borderTop)
        numberTextField.layer.addSublayer(borderBottom)
    }
}

extension AuthEnterNumberViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 16
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
}

extension AuthEnterNumberViewController: AuthEnterNumberViewControllerProtocol {
    func showErrorAlert(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
}

class AuthPhoneNumberTextField: PhoneNumberTextField {
    override var defaultRegion: String {
        get {
            "RU"
        }
        set {}
    }
}
