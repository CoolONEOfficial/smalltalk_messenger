//
//  BottomBarViewController.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 10.03.2020.
//

import Foundation
import UIKit

class BottomBarViewController: UITabBarController {
    var chatList: UIViewController! {
        didSet {
            chatList.tabBarItem = .init(title: "Chats", image: #imageLiteral(resourceName: "ic_chat"), selectedImage: #imageLiteral(resourceName: "ic_chat"))
            chatList.tabBarItem.tag = 1
        }
    }
    var settings: UIViewController! {
        didSet {
            settings.tabBarItem = .init(title: "Settings", image: #imageLiteral(resourceName: "ic_settings"), selectedImage: #imageLiteral(resourceName: "ic_settings"))
            settings.tabBarItem.tag = 2
        }
    }
    var contacts: UIViewController! {
        didSet {
            contacts.tabBarItem = .init(tabBarSystemItem: .contacts, tag: 0)
        }
    }
    
    lazy var controllers: [UIViewController] = {
        return [contacts, chatList, settings]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewControllers = controllers
        selectedIndex = 1
        title = selectedViewController?.tabBarItem.title
    }
}

extension BottomBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        title = viewController.tabBarItem.title
        
        return true
    }
    
}
