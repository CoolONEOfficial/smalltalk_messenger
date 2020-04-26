//
//  SettingsStartViewController.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 03.04.2020.
//

import UIKit
import Firebase
import FirebaseUI
import CodableFirebase
import Reusable

protocol SettingsStartViewControllerProtocol {
    func userDidUpdate()
}

class SettingsStartViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var avatar: AvatarView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    
    enum Constants {
        static let headerHeight: CGFloat = 350
        static let imageSize: CGFloat = 250
        static let yShift: CGFloat = 30
        static let xShift: CGFloat = 20
    }
    
    var viewModel: SettingsStartViewModelProtocol!
    let searchController = UISearchController(searchResultsController: nil)
    
    private var currentUser = Auth.auth().currentUser
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .userBackground
        tabBarController?.title = "Settings"
        editButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad()
    }
    
    private func editButton() {
        tabBarController?.navigationItem.rightBarButtonItem = .init(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(didEditTap)
        )
    }
    
    // MARK: - Actions
    
    @objc func didEditTap() {
        viewModel.showSettingsEdit()
    }
}

extension SettingsStartViewController: SettingsStartViewControllerProtocol {
    func userDidUpdate() {
        nameLabel.text = viewModel.userModel?.fullName
        phoneLabel.text = viewModel.userModel?.phoneNumber
        avatar.setup(withUser: viewModel.userModel!)
    }
}
