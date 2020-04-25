//
//  UIViewController.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 11.04.2020.
//

import UIKit

extension UIViewController {

    func presentErrorAlert(_ text: String) {
        let alert = UIAlertController(
            title: "Error",
            message: text,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Dismiss", style: .cancel))
        alert.view.tintColor = .accent
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    private struct ActivityAlert {
        static var activityIndicatorAlert: UIAlertController?
    }
    
    func presentActivityAlert() {
        ActivityAlert.activityIndicatorAlert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        ActivityAlert.activityIndicatorAlert!.view.addSubview(loadingIndicator)

        var topController: UIViewController = UIApplication.keyWindow!.rootViewController!
        while (topController.presentedViewController) != nil {
            topController = topController.presentedViewController!
        }

        topController.present(ActivityAlert.activityIndicatorAlert!, animated: true, completion: nil)
    }

    func dismissActivityAlert(completion: (() -> Void)? = nil) {
        ActivityAlert.activityIndicatorAlert!.dismiss(animated: true, completion: completion)
        ActivityAlert.activityIndicatorAlert = nil
    }
    
    // MARK: - Tabbar show/hide helper
    
    func setTabBarHidden(
        _ hidden: Bool,
        animated: Bool = true,
        duration: TimeInterval = 0.3,
        completion: @escaping () -> Void = {}
    ) {
        if animated,
            let tabbar = tabBarController?.tabBar {
            if !hidden {
                tabbar.isHidden = false
            }
            UIView.animate(withDuration: duration, animations: {
                tabbar.alpha = hidden ? 0.0 : 1.0
            }) { _ in
                completion()
                if hidden {
                    tabbar.isHidden = true
                }
            }
            return
        }
        self.tabBarController?.tabBar.isHidden = hidden
    }
}
