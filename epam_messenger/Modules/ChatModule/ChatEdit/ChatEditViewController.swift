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
    
    @IBOutlet var avatar: AvatarEditView!
    @IBOutlet var titleField: UITextField!
    lazy var imagePickerService: ImagePickerServiceProtocol =
        ImagePickerService(viewController: self, cameraDevice: .rear)
    
    // MARK: - Vars
    
    var viewModel: ChatEditViewModelProtocol!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTitleField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupAvatar()
    }
    
    private func setupTitleField() {
        if case .chat(let title, _, _, _) = viewModel.chatModel.type {
            titleField.text = title
        }
    }
    
    private func setupAvatar() {
        if case .chat(let title, _, let hexColor, let isAvatarExists) = viewModel.chatModel.type {
            avatar.imagePickerService = imagePickerService
            let placeholderText = String(title.first!)
            let placeholderColor = UIColor(hexString: hexColor) ?? .accent
            if isAvatarExists != nil {
                avatar.setup(
                    withRef: viewModel.chatModel.avatarRef!,
                    text: placeholderText,
                    color: placeholderColor
                )
            } else {
                avatar.setup(
                    withPlaceholder: placeholderText,
                    color: placeholderColor
                )
            }
            avatar.delegate = self
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = .init(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didCancelTap)
        )
        navigationItem.leftBarButtonItem?.tintColor = UIColor.lightText.withAlphaComponent(1)
        
        navigationItem.rightBarButtonItem = .init(
            title: "Apply",
            style: .done,
            target: self,
            action: #selector(didApplyTap)
        )
        navigationItem.rightBarButtonItem?.tintColor = UIColor.lightText.withAlphaComponent(1)
    }

    // MARK: - Actions
    
    @IBAction func didTitleChange(_ sender: Any) {
        guard case .chat(_, _, let chatColorHex, _) = viewModel.chatModel.type else { return }
        avatar.setup(
            withPlaceholder: titleField.text?.first != nil ? String(titleField.text!.first!) : nil,
            color: UIColor(hexString: chatColorHex) ?? .accent
        )
        viewModel.chatModel.type.changeChat(newTitle: titleField.text)
    }
    
    @objc func didApplyTap() {
        presentActivityAlert()
        viewModel.updateChat { [weak self] err in
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
    }
    
    func didChangeColor(_ color: UIColor) {
        viewModel.chatModel.type.changeChat(newHexColor: color.hexString)
    }

}
