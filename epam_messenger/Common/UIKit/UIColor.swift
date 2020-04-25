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
    
    // MARK: - Secondary elements
    
    static let secondary = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
            return UIColor.lightText.withAlphaComponent(0.8)
        } else {
            return .systemIndigo
        }
    }
    
    // MARK: - UserSettings
    
    static let userBackground = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
            return UIColor.black
        } else {
            return UIColor.white        }
    }
}

extension UIColor {
    convenience init(hex: Int) {
        self.init(hex: hex, a: 1.0)
    }

    convenience init(hex: Int, a: CGFloat) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }

    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }

    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }

    convenience init?(hexString: String?) {
        guard let hex = hexString?.hex else {
            return nil
        }
        self.init(hex: hex)
    }
    
    var hexString: String {
        let components = cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}

fileprivate extension String {
    var hex: Int? {
        return Int(self.suffix(6), radix: 16)
    }
}

extension UIColor {
    static func blend(color1: UIColor, intensity1: CGFloat = 0.5, color2: UIColor, intensity2: CGFloat = 0.5) -> UIColor {
        let total = intensity1 + intensity2
        let l1 = intensity1/total
        let l2 = intensity2/total
        guard l1 > 0 else { return color2}
        guard l2 > 0 else { return color1}
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2)
    }
}
