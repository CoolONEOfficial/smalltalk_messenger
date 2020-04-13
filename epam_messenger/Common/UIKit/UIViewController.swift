//
//  UIViewController.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 11.04.2020.
//

import UIKit

extension UIViewController {

    func presentErrorAlert(_ text: String) {
        let alert = UIAlertController(title: "Error",
                                      message: text,
                                      preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
