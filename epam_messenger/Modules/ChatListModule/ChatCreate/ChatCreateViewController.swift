//
//  ChatCreateViewController.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 20.04.2020.
//

import UIKit
import FirebaseAuth
import SDWebImage
import FirebaseUI.FUIStorageImageLoader

protocol ChatCreateViewControllerProtocol {
    
}

class ChatCreateViewController: UIViewController, ChatCreateViewControllerProtocol {

    // MARK: - Outlets
    
    @IBOutlet var avatar: AvatarEditView!
    @IBOutlet var titleField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Vars
    
    var viewModel: ChatCreateViewModelProtocol!
    
    lazy var imagePickerService = ImagePickerService(viewController: self, cameraDevice: .rear)
    
    var chatModel: ChatModel = .empty()
    var chatAvatar: UIImage?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAvatar()
        setupTableView()
        setupRightCreateButton()
    }
    
    private func setupAvatar() {
        avatar.setup(withPlaceholder: "")
        avatar.imagePickerService = imagePickerService
        avatar.delegate = self
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: UserCell.self)
    }
    
    private func setupRightCreateButton() {
        let createButton = UIBarButtonItem(
            title: "Create",
            style: .done,
            target: self,
            action: #selector(didCreateTap)
        )
        createButton.isEnabled = false
        
        navigationItem.setRightBarButton(
            createButton,
            animated: false
        )
    }
    
    // MARK: - Actions

    @objc func didCreateTap() {
        presentActivityAlert()
        viewModel.createChat(
            chatModel: chatModel,
            avatar: chatAvatar
        ) { [weak self] err in
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
    
    @IBAction func didTitleChanged(_ sender: Any) {
        let newTitle = titleField.text
        chatModel.type.changeChat(newTitle: newTitle)
        if case .chat(_, _, let colorHex) = chatModel.type {
            avatar.setup(
                withPlaceholder: newTitle?.first != nil
                    ? String(newTitle!.first!)
                    : nil,
                color: (colorHex != nil ? UIColor(hexString: colorHex!) : nil) ?? .accent
            )
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = !(newTitle?.isEmpty ?? true)
    }
}

extension ChatCreateViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == chatModel.users.count {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "Add user"
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UserCell.self)
            cell.loadUser(byId: chatModel.users[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatModel.users.count + 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let oldUsers = self.chatModel.users
            self.chatModel.users.remove(at: indexPath.row)
            tableView.animateRowChanges(oldData: oldUsers, newData: self.chatModel.users)
        }
    }
    
    public func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        indexPath.row < chatModel.users.count &&
            chatModel.users[indexPath.row] != Auth.auth().currentUser!.uid
            ? .delete
            : .none
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        header.contentView.backgroundColor = .secondarySystemBackground
    }
    
}

extension ChatCreateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Users"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == chatModel.users.count {
            viewModel.showUserPicker(selectDelegate: self)
        }
    }
    
}

extension ChatCreateViewController: ContactsSelectDelegate {
    
    func didSelectUser(_ userId: String) {
        let oldUsers = chatModel.users
        chatModel.users.append(userId)
        tableView.animateRowChanges(oldData: oldUsers, newData: chatModel.users)
    }
    
}

extension ChatCreateViewController: AvatarEditViewDelegate {
    
    func didChangeImage(_ image: UIImage) {
        chatAvatar = image
    }
    
    func didChangeColor(_ color: UIColor) {
        chatModel.type.changeChat(newHexColor: color.hexString)
    }
    
}
