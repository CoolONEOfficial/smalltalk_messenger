//
//  ChatEditViewController.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 21.04.2020.
//

import UIKit
import SDWebImage

protocol ChatEditViewControllerProtocol {
}

class ChatEditViewController: UIViewController, ChatEditViewControllerProtocol {

    // MARK: - Outlets
    
    @IBOutlet var stack: UIStackView!
    @IBOutlet var contactNameField: UITextField!
    @IBOutlet var chatTitleField: UITextField!
    
    // MARK: - Vars
    
    var viewModel: ChatEditViewModelProtocol!
    
    var chatAvatar: AvatarEditView = .init()
    var contactAvatar: AvatarView = .init()
    
    lazy var imagePickerService: ImagePickerServiceProtocol =
        ImagePickerService(viewController: self, cameraDevice: .rear)
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch viewModel.chatModel.type {
        case .personalCorr:
            viewModel.contactGroup.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                self.setupContactAvatar()
                self.setupContactNameField()
            }
        case .chat(let chatData):
            setupChatAvatar(chatData)
            setupChatTitleField(chatData)
        default: break
        }
    }
    
    private func setupChatTitleField(
        _ chatData: (title: String, adminId: String, hexColor: String?, avatarPath: String?)
    ) {
        chatTitleField.text = chatData.title
        chatTitleField.isHidden = false
    }
    
    private func setupContactNameField() {
        contactNameField.text = viewModel.chatModel.friendName
        contactNameField.isHidden = false
    }
    
    private func setupContactAvatar() {
        stack.insertArrangedSubview(contactAvatar, at: 0)
        contactAvatar.size(.init(width: 120, height: 120))
        viewModel.loadFriend { [weak self] userModel in
            guard let self = self else { return }
            self.contactAvatar.setup(withUser: userModel ?? .deleted())
        }
    }
    
    private func setupChatAvatar(
        _ chatData: (title: String, adminId: String, hexColor: String?, avatarPath: String?)
    ) {
        stack.insertArrangedSubview(chatAvatar, at: 0)
        chatAvatar.size(.init(width: 120, height: 120))
        
        chatAvatar.imagePickerService = imagePickerService
        let placeholderText = String(chatData.title.first!)
        let placeholderColor = UIColor(hexString: chatData.hexColor) ?? .accent
        if chatData.avatarPath != nil {
            chatAvatar.setup(
                withRef: viewModel.chatModel.avatarRef!,
                text: placeholderText,
                color: placeholderColor,
                cornerRadius: 60
            )
        } else {
            chatAvatar.setup(
                withPlaceholder: placeholderText,
                color: placeholderColor,
                cornerRadius: 60
            )
        }
        chatAvatar.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = .init(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didCancelTap)
        )
        
        navigationItem.rightBarButtonItem = .init(
            title: "Apply",
            style: .done,
            target: self,
            action: #selector(didApplyTap)
        )
    }

    // MARK: - Actions
    
    @IBAction func didContactNameChange(_ sender: Any) {
        viewModel.contactModel.localName = contactNameField.text ?? ""
    }
    
    @IBAction func didChatTitleChange(_ sender: Any?) {
        guard case .chat(_, _, let chatColorHex, _) = viewModel.chatModel.type else { return }
        let ph = chatTitleField?.text?.first != nil ? String(chatTitleField.text!.first!) : nil
        chatAvatar.setup(
            withPlaceholder: ph,
            color: UIColor(hexString: chatColorHex) ?? .accent
        )
        viewModel.chatModel.type.changeChat(newTitle: chatTitleField.text)
    }
    
    @objc func didApplyTap() {
        presentActivityAlert()
        viewModel.applyChanges { [weak self] err in
            guard let self = self else { return }
            self.dismissActivityAlert {
                if let err = err {
                    self.presentErrorAlert(err.localizedDescription)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func didCancelTap() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}

extension ChatEditViewController: AvatarEditViewDelegate {
    
    func didChangeImage(_ image: UIImage?) {
        viewModel.chatAvatar = image
        viewModel.chatModel.type.changeChat(clearAvatarPath: image == nil)
        if image == nil {
            didChatTitleChange(nil)
        }
    }
    
    func didChangeColor(_ color: UIColor) {
        viewModel.chatModel.type.changeChat(newHexColor: color.hexString)
    }

}
