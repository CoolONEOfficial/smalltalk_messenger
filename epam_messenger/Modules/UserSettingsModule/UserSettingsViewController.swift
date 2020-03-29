//
//  UserSettingsViewController.swift
//  epam_messenger
//
//  Created by Anna Krasilnikova on 12.03.2020.
//

import UIKit
import Firebase
import FirebaseUI
import CodableFirebase
import Reusable

protocol UserSettingsViewControllerProtocol {
}

class UserSettingsViewController: UIViewController {
    var viewModel: UserSettingsViewModelProtocol!

    @IBOutlet weak var userSettingsTableView: UITableView!
    @IBOutlet weak var userImageView: UIImageView!
    
    private var imageViewLayoutSet: LayoutConstraintSet?
    private var userNameLabelLayoutSet: LayoutConstraintSet?
    private var userStatusLabelLayoutSet: LayoutConstraintSet?
    
    private lazy var widthSafeArea = CGFloat.init()
    private lazy var heightSafeArea = CGFloat.init()
    
    private lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel(frame: CGRect.zero)
        userNameLabel.numberOfLines = 2
        userNameLabel.text = "Тестовый Тест"
        self.view.addSubview(userNameLabel)
        return userNameLabel
    }()
    
//    private lazy var userStatusLabel: UILabel = {
//        let userStatusLabel = UILabel(frame: CGRect.zero)
//        userStatusLabel.numberOfLines = 0
//        return userStatusLabel
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "User Settings"
        userSettingsTableView.delegate = self
        
        setupUserImageView(image: userImageView)
        setupUserImageConstraints(object: userImageView, isLandscape: UIDevice.current.orientation.isLandscape)
        let imageLongPress = UILongPressGestureRecognizer(target: self, action: #selector(isImageLongPress(sender:)))
        self.userImageView.addGestureRecognizer(imageLongPress)
    }

    private func setupUserImageView(image: UIImageView) {
        image.image = #imageLiteral(resourceName: "Dan-Leonard")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = image.bounds.width / 2
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false

//        userStatusLabel.text = "Online"
    }
    
    private func setupUserImageConstraints(object: UIView, isLandscape: Bool) {
        imageViewLayoutSet = LayoutConstraintSet(
            top: object.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            left: object.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            width: object.widthAnchor.constraint(equalToConstant: 130),
            height: object.heightAnchor.constraint(equalToConstant: 130)
        ).activate()
        userNameLabelLayoutSet = LayoutConstraintSet(
            top: userNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            left: userNameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 170),
            right: userNameLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 20)
        ).activate()
    }
    
    @IBAction func isImageResized(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        guard let gestureView = gesture.view else { return }
        guard gesture.state == .ended else { return }
        print(location)
        if location.x + location.y > 450 {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseIn,
                animations: {
                    gestureView.layer.cornerRadius = 0
                    self.updateContainerPadding(layoutSet: self.imageViewLayoutSet,
                                                top: 0,
                                                left: 0,
                                                width: self.widthSafeArea,
                                                height: self.heightSafeArea / 3
                    )
                }
            )
        }
        if location.x + location.y < 350 {
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                options: .curveEaseOut,
                animations: {
                    self.updateContainerPadding(layoutSet: self.imageViewLayoutSet,
                                                top: 20,
                                                left: 20,
                                                width: 130,
                                                height: 130)
                }
            )
        }
    }
    
    private func updateContainerPadding(layoutSet: LayoutConstraintSet?, top: CGFloat, left: CGFloat, width: CGFloat, height: CGFloat) {

        layoutSet?.top?.constant = top//0
        layoutSet?.left?.constant = left//0
//        if isLandscape {
//            layoutSet?.width?.constant = 300
 //       } else {
            layoutSet?.width?.constant = width//view.safeAreaLayoutGuide.layoutFrame.size.width
 //       }
//        if isLandscape {
        layoutSet?.height?.constant = height//view.safeAreaLayoutGuide.layoutFrame.size.height / 3
//        } else {
//            layoutSet?.height?.constant = 300
//        }
        
    }
    
    @objc private func isImageLongPress(sender: UILongPressGestureRecognizer) {
        print("Long press")
//        if sender.state == .began {
//        print("Long press began")
//        self.becomeFirstResponder()
////        self.viewForReset = gestureRecognizer.view
////
////        // Configure the menu item to display
//        let menuItemTitle = NSLocalizedString("Reset", comment: "Reset menu item title")
//        let action = #selector(UserSettingsViewController.doSome)
//        let resetMenuItem = UIMenuItem(title: menuItemTitle, action: action)
////
////        // Configure the shared menu controller
//        let menuController = UIMenuController.shared
//        menuController.menuItems = [resetMenuItem]
////
////        // Set the location of the menu in the view.
//        let location = sender.location(in: sender.view)
//        let menuLocation = CGRect(x: location.x, y: location.y, width: 0, height: 0)
//        menuController.setTargetRect(menuLocation, in: sender.view!)
////
////        // Show the menu.
//        menuController.setMenuVisible(true, animated: true)
//        }
    }
    
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        updateContainerPadding(layoutSet: imageViewLayoutSet, isLandscape: UIDevice.current.orientation.isLandscape)
//    }
//
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        widthSafeArea = view.safeAreaLayoutGuide.layoutFrame.size.width
        heightSafeArea = view.safeAreaLayoutGuide.layoutFrame.size.height

    }
    
    @objc func doSome() {
        
    }
}

extension UserSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: - load data from tableView
    }
}

extension UserSettingsViewController: UserSettingsViewControllerProtocol {}
