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
            return .systemIndigo
        } else {
            return .systemIndigo
        }
    }
    
    static let accentText = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
            return UIColor.lightText.withAlphaComponent(0.8)
        } else {
            return UIColor.lightText.withAlphaComponent(1)
        }
    }
    
    // MARK: - Elements
    
    static let plainText = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
            return UIColor.lightText.withAlphaComponent(0.8)
        } else {
            return .darkText
        }
    }
    
    static let plainBackground = UIColor.systemGray3.withAlphaComponent(0.5)
    
    static let plainIcon = UIColor.systemGray
    
    // MARK: - Chat header
    
    static let chatRectLabelText = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
            return UIColor.lightText.withAlphaComponent(0.8)
        } else {
            return UIColor.lightText.withAlphaComponent(1)
        }
    }
    
    static let chatRectLabelBackground = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        } else {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
    }
}
