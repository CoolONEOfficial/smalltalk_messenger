//
//  UIDevice.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 16.03.2020.
//

import UIKit

extension UIDevice {

    /// Returns 'true' if the device has a notch
    var hasNotch: Bool {
        let window = (UIApplication.shared.windows.first { $0.isKeyWindow })!
        
        if window.windowScene?.interfaceOrientation.isPortrait ?? false {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }

}
