//
//  AuthEnterNumberViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import UIKit

protocol AuthEnterNumberViewControllerProtocol {
    func showErrorAlert(_ text: String)
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
    
    func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+X (XXX) XXX-XXXX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

extension AuthEnterNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedNumber(number: newString)
        return false
    }
}

extension AuthEnterNumberViewController: AuthEnterNumberViewControllerProtocol {
    func showErrorAlert(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
}
