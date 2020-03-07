//
//  ChatsViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 07.03.2020.
//

import UIKit

class ChatsViewController: UIViewController {
    var viewModel: ChatsViewModelProtocol!

    @IBAction func touchGoToChat() {
        viewModel.goToChat()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chats"
    }
}
