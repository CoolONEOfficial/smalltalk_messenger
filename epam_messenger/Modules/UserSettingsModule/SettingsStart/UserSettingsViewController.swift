//
//  UserSettingsViewController.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 03.04.2020.
//

import UIKit
import Firebase
import FirebaseUI
import CodableFirebase
import Reusable

protocol UserSettingsDelegateProtocol {
}

protocol UserSettingsViewControllerProtocol {
    func userDidUpdate()
}

class UserSettingsViewController: UIViewController {
    
    enum Constants {
        static let headerHeight: CGFloat = 350
        static let imageSize: CGFloat = 250
        static let yShift: CGFloat = 30
        static let xShift: CGFloat = 20
    }
    
    var userImageView: AvatarView!
    var userNameLabel = UILabel()
    var userPhoneLabel = UILabel()
    var userStatusLabel = UILabel()
    var viewModel: UserSettingsViewModelProtocol!
    var userSettingsDelegate: UserSettingsDelegateProtocol?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var currentUser = Auth.auth().currentUser
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .userBackground
        tabBarController?.title = "User Settings"
        setupSearchController()
        editButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad()
        
        setUpUserInfo()
        setUpConstrants()
    }
    
    private func setupSearchController() {
        searchController.searchBar.placeholder = "Search settings"
        tabBarController?.navigationItem.searchController = searchController
    }
    
    private func editButton() {
        let editButton = UIButton(type: .custom)
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.accent, for: .normal)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        editButton.addTarget(self, action: #selector(touchEdit), for: .touchUpInside)
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }
    
    private func setUpUserInfo() {
        userImageView = AvatarView()
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userImageView)
        
        userNameLabel = UILabel()
        userNameLabel.font = UIFont.systemFont(ofSize: 17)
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameLabel)
        
        userPhoneLabel = UILabel()
        userPhoneLabel.textColor = .plainText
        userPhoneLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userPhoneLabel)
        
        userStatusLabel = UILabel()
        userStatusLabel.textColor = .plainText
        userStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userStatusLabel)
        
    }
    
    func setUpConstrants() {
        let safeArea = view.safeAreaLayoutGuide
        //userImageView.top(to: safeArea)
        let constraints: [NSLayoutConstraint] = [
            
            userImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            userImageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            userImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            userImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            
            userNameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.xShift),
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: Constants.yShift),
            userNameLabel.heightAnchor.constraint(equalToConstant: Constants.yShift),
            
            userStatusLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.yShift),
            userStatusLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            
            userPhoneLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: Constants.xShift / 2),
            userPhoneLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func touchEdit() {
        viewModel.showUserInfoEdit()
    }
}

extension UserSettingsViewController: UserSettingsViewControllerProtocol {
    func userDidUpdate() {
        self.userNameLabel.text = viewModel.userModel?.fullName
        self.userPhoneLabel.text = viewModel.userModel?.phoneNumber
        self.userStatusLabel.text = viewModel.userModel?.onlineText
        self.userStatusLabel.textColor = viewModel.userModel?.online ?? false
            ? .plainText
            : .secondaryLabel
        self.userImageView.setup(withUser: viewModel.userModel!, roundCorners: false)
    }
}
