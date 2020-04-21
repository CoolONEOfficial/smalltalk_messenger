//
//  AuthEnterNameViewController.swift
//  epam_messenger
//
//  Created by Anton Pryakhin on 09.03.2020.
//

import UIKit
import ChromaColorPicker

protocol AuthEnterInitialsViewControllerProtocol: UIViewController {
    
}

class AuthEnterInitialsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var avatar: AvatarEditView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var surnameField: UITextField!
    
    // MARK: - Vars
    
    var viewModel: AuthEnterInitialsViewModelProtocol!
    lazy var imagePickerService = ImagePickerService(viewController: self, cameraDevice: .front)
    
    var user: UserModel = .empty()
    var userImage: UIImage?
    
    var nextButton = UIButton(type: .custom)
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNextButton()
        setupAvatar()
        setupNameLabel()
        setupSurnameLabel()
    }
    
    private func setupNextButton() {
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.accent, for: .normal)
        nextButton.setTitleColor(UIColor.accent.withAlphaComponent(0.5), for: .disabled)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        nextButton.addTarget(nil, action: #selector(touchNext), for: .touchUpInside)
        updateNextButton()

        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextButton)
    }
    
    private func setupNameLabel() {
        nameField.delegate = self
        nameField.becomeFirstResponder()
    }
    
    private func setupSurnameLabel() {
        surnameField.delegate = self
    }
    
    private func setupAvatar() {
        avatar.delegate = self
        avatar.imagePickerService = imagePickerService
        avatar.setup(withPlaceholder: "")
    }
    
    // MARK: - Actions

    @objc func touchNext() {
        let alertView = UIAlertController(title: "Please wait", message: "Creating user", preferredStyle: .alert)

        present(alertView, animated: true, completion: { [weak self] in
            guard let self = self else { return }
            let progressView = UIProgressView()
            progressView.progress = 0
            progressView.tintColor = self.view.tintColor
            alertView.view.addSubview(progressView)
            progressView.bottomToSuperview(offset: -10)
            progressView.horizontalToSuperview()
            progressView.clipsToBounds = true
            
            self.viewModel.createUser(
                userModel: self.user,
                avatar: self.avatar.image,
                progressAddiction: { addiction in
                    progressView.setProgress(progressView.progress + addiction, animated: true)
            }) { err in
                self.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    if let err = err {
                        self.presentErrorAlert(err.localizedDescription)
                    }
                }
            }
        })
    }
    
    @IBAction func didNameChanged(_ sender: Any) {
        user.name = nameField.text ?? ""
        if userImage == nil {
            avatar.setup(withPlaceholder: user.placeholderName)
        }
        updateNextButton()
    }

    @IBAction func didSurnameChanged(_ sender: Any) {
        user.surname = surnameField.text ?? ""
        if userImage == nil {
            avatar.setup(withPlaceholder: user.placeholderName)
        }
        updateNextButton()
    }
    
    private func updateNextButton() {
        nextButton.isEnabled =
            validateInitial(nameField.text) &&
            validateInitial(surnameField.text)
        
    }
    
    private func validateInitial(_ initial: String?) -> Bool {
        guard let initial = initial else { return false }
        return !initial.isEmpty && initial.isLettersOnly
    }
    
    @objc func galleryDidTap() {
        imagePickerService.pickSinglePhoto(completion: didImageSelect(image:))
    }
    
    @objc func cameraDidTap() {
        imagePickerService.pickCamera(completion: didImageSelect(image:), device: nil)
    }
    
    @objc func cancelOrColorWheelDidTap() {
        if userImage == nil { // color wheel
            let vc = ColorPickerViewController(
                initialColor: user.color ?? UIColor.accent
            )
            vc.modalPresentationStyle = .overCurrentContext
            vc.isHeroEnabled = true
            vc.delegate = self
            navigationController?.hero.isEnabled = true
            present(vc, animated: true, completion: nil)
        } else { // cancel
            userImage = nil
        }
    }
    
    func didImageSelect(image: UIImage) {
        userImage = image
    }
}

extension AuthEnterInitialsViewController: AvatarEditViewDelegate {
    
    func didChangeImage(_ image: UIImage) {
        userImage = image
    }
    
    func didChangeColor(_ color: UIColor) {
        user.color = color
    }
    
}

extension AuthEnterInitialsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            surnameField.becomeFirstResponder()
            return false
        case surnameField:
            touchNext()
            return false
        default:
            return true
        }
    }
    
}

extension AuthEnterInitialsViewController: ChromaColorPickerDelegate {
    
    func colorPickerHandleDidChange(_ colorPicker: ChromaColorPicker, handle: ChromaColorHandle, to color: UIColor) {
        avatar.backgroundColor = color
        user.color = color
    }
    
}

extension AuthEnterInitialsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            if let image = image {
                self.userImage = image
            } else {
                debugPrint("error while unwrapping selected image")
            }
        }
    }
    
}

extension AuthEnterInitialsViewController: AuthEnterInitialsViewControllerProtocol {
    
}

// MARK: String validation helper

fileprivate extension String {
    
    var isLettersOnly: Bool {
        CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
}
