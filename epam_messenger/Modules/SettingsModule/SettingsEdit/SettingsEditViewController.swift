//
//  SettingsEditViewController.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 23.04.2020.
//

import UIKit
import Firebase
import FirebaseAuth
import CodableFirebase
import Reusable

protocol SettingsEditViewControllerProtocol {}

class SettingsEditViewController: UIViewController, SettingsEditViewControllerProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var avatar: AvatarEditView!
    
    // MARK: - Vars
    
    var viewModel: SettingsEditViewModelProtocol!
    
    lazy var imagePickerService = ImagePickerService(viewController: self, cameraDevice: .front)
    
    private var phone = ""
    private var placeholder = ""
    
    // MARK: - Init
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .userBackground
        title = "Edit profile"
        setupApplyButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupAvatar()
        
        initialSetup()
    }
    
    func initialSetup() {
        nameField.text = viewModel.userModel.name
        surnameField.text = viewModel.userModel.surname
        placeholder = viewModel.userModel.placeholderName
        avatar.setup(withUser: viewModel.userModel)
    }
    
    private func setupAvatar() {
        avatar.imagePickerService = imagePickerService
        avatar.delegate = self
    }
    
    private func setupApplyButton() {
        navigationItem.rightBarButtonItem = .init(
            title: "Apply",
            style: .done,
            target: self,
            action: #selector(didApplyTap)
        )
    }
    
    // MARK: - Actions
    
    @IBAction func signOutButtonTap(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "",
            message: "Do you really want to sign out?",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ -> Void in
            do {
                try Auth.auth().signOut()
                self.viewModel.goToInitialView()
            } catch let err {
                print(err)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func didApplyTap() {
        presentActivityAlert()
        self.viewModel.updateUser { [weak self] err in
            guard let self = self else { return }
            self.dismissActivityAlert {
                if let err = err {
                    self.presentErrorAlert(err.localizedDescription)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func nameDidUpdate(_ sender: Any) {
        viewModel.userModel.name = nameField.text ?? ""
        if viewModel.userAvatar == nil {
            avatar.setup(
                withPlaceholder: viewModel.userModel.placeholderName,
                color: viewModel.userModel.color
            )
        }
    }
    @IBAction func surnameDidUpdate(_ sender: Any) {
        viewModel.userModel.surname = surnameField.text ?? ""
        if viewModel.userAvatar == nil {
            avatar.setup(
                withPlaceholder: viewModel.userModel.placeholderName,
                color: viewModel.userModel.color
            )
        }
    }
}

extension SettingsEditViewController: AvatarEditViewDelegate {
    func didChangeImage(_ image: UIImage?) {
        viewModel.userAvatar = image
        if image == nil {
            self.viewModel.userModel.avatarPath = nil
        }
    }
    
    func didChangeColor(_ color: UIColor) {
        viewModel.userModel.color = color
    }
}
