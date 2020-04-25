//
//  UserInfoEditViewController.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 23.04.2020.
//

import UIKit
import Firebase
import FirebaseUI
import CodableFirebase
import Reusable

protocol UserInfoEditViewControllerProtocol {
}

protocol UserSelectDelegate: AnyObject {
}

class UserInfoEditViewController: UIViewController {
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userSurname: UITextField!
    @IBOutlet weak var userAvatar: AvatarEditView!
    
    let currentUser = Auth.auth().currentUser!
    
    var viewModel: UserInfoEditViewModelProtocol!
    
    lazy var imagePickerService = ImagePickerService(viewController: self, cameraDevice: .rear)
    
    private var phone = ""
    private var placeholder = ""
    
    var userImage: UIImage!
    var userColor: UIColor!
    
    var user: UserProtocol? {
        didSet {
            self.userName.text = user?.name
            self.userSurname.text = user?.surname
            self.userAvatar.backgroundColor = user?.color
            self.placeholder = user!.placeholderName
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .userBackground
        title = "Edit profile"
        applyButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser(byId: currentUser.uid)
        setupAvatar()
    }
    
    @IBAction func signOutButtonTap(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "",
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
    
    private func setupAvatar() {
        userAvatar.imagePickerService = imagePickerService
        userAvatar.delegate = self
    }
    
    private func applyButton() {
        let applyButton = UIButton(type: .custom)
        applyButton.setTitle("Apply", for: .normal)
        applyButton.setTitleColor(.accent, for: .normal)
        applyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        applyButton.addTarget(self, action: #selector(touchSave), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: applyButton)
    }
    
    @IBAction func nameDidUpdate(_ sender: Any) {
        viewModel.userModel.name = userName.text ?? ""
        userAvatar.setup(
            withPlaceholder: viewModel.userModel.placeholderName,
            color: user?.color ?? .accent
        )
    }
    @IBAction func surnameDidUpdate(_ sender: Any) {
        viewModel.userModel.surname = userSurname.text ?? ""
        userAvatar.setup(
            withPlaceholder: viewModel.userModel.placeholderName,
            color: user?.color ?? .accent
        )
    }
    
    @objc func touchSave() {
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
    
    func loadUser(byId userId: String, completion: ((UserModel?) -> Void)? = nil) {
        FirestoreService().listenUserData(userId) { [weak self] user in
            guard let self = self else { return }
            self.userAvatar.setup(withUser: user!)
            self.user = user ?? .deleted(userId)
            completion?(user)
        }
    }
}

extension UserInfoEditViewController: UserInfoEditViewControllerProtocol {
    
}

extension UserInfoEditViewController: UserSelectDelegate {
    
}

extension UserInfoEditViewController: AvatarEditViewDelegate {
    func didChangeImage(_ image: UIImage?) {
        userImage = image
        viewModel.userAvatar = image
    }
    
    func didChangeColor(_ color: UIColor) {
        userColor = color
        viewModel.userColor = color
    }
}
