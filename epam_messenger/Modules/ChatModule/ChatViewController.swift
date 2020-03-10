//
//  ChatViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 08.03.2020.
//

import UIKit

class ChatViewController: UIViewController {
    var viewModel: ChatViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chat"
    }
}
