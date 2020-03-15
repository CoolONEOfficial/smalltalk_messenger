//
//  UIColor.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 15.03.2020.
//

import UIKit

// MARK: Color constants

extension UIColor {
    // MARK: - Accent
    
    static let accent = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 87/255, green: 85/255, blue: 218/255, alpha: 0.8)
        } else {
            return UIColor(red: 87/255, green: 85/255, blue: 218/255, alpha: 1)
        }
    }
    
    static let accentText = UIColor.lightText
    
    // MARK: - Elements
    
    static let plainText = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
            return .lightText
        } else {
            return .darkText
        }
    }
    
    static let plainBackground = UIColor.systemGray2.withAlphaComponent(0.5)
    
    // MARK: - Chat header
    
    static let chatDateHeaderText = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
            return UIColor.lightText
        } else {
            return UIColor.lightText.withAlphaComponent(1)
        }
    }
    
    static let chatDateHeaderBackground = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        } else {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
    }
}
