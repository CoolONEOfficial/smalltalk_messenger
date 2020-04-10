//
//  UIApplication.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 10.04.2020.
//

import UIKit

extension UIApplication {
    static var safeAreaInsets: UIEdgeInsets {
        let window = (UIApplication.shared.windows.first { $0.isKeyWindow })!
        return window.safeAreaInsets
    }
}
