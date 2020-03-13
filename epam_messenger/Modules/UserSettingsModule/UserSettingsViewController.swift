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
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "User Settings"
        userSettingsTableView.delegate = self
        
        setImageView(image: userImageView)
    }
    
    func setImageView(image: UIImageView) {
        image.image = #imageLiteral(resourceName: "Dan-Leonard")
        image.layer.cornerRadius = userImageView.bounds.width / 2
        image.isUserInteractionEnabled = true
    }
    
    func isImageResized(image: UIImageView) {
        
    }

}

extension UserSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: - load data from tableView
    }
}

extension UserSettingsViewController: UserSettingsViewControllerProtocol {}
