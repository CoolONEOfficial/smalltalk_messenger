//
//  ChatDetailsViewController.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 09.04.2020.
//

import UIKit
import Hero

protocol ChatDetailsViewControllerProtocol {
    
}

class ChatDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet var stack: UIStackView!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var usersTableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    // MARK: - Vars
    
    var viewModel: ChatDetailsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupAvatar()
        setupTableView()
        setupInfo()
    }
    
    private func setupInfo() {
        viewModel.chat.loadInfo { title, subtitle in
            self.transitionSubtitleLabel {
                self.titleLabel.text = title
                self.subtitleLabel.text = subtitle
            }
        }
        subtitleLabel.text = "\(viewModel.chat.users.count) users"
    }
    
    private func transitionSubtitleLabel(
        animations: (() -> Void)?
    ) {
        UIView.transition(
            with: self.subtitleLabel,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: animations,
            completion: nil
        )
    }
    
    private func setupTableView() {
        usersTableView.register(cellType: UserCell.self)
        usersTableView.height(view.bounds.height)
        usersTableView.dataSource = self
    }
    
    private func setupNavigationBar() {
        let navBar = navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.isTranslucent = true
        navigationController?.view.backgroundColor = .clear

        navigationItem.leftBarButtonItem = .init(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(didCancelTap)
        )
    }
    
    private func setupAvatar() {
        avatarImage.top(to: view, priority: .defaultHigh)
        avatarImage.sd_setImage(with: viewModel.chat.avatarRef, placeholderImage: #imageLiteral(resourceName: "logo"))
    }

    @objc func didCancelTap() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension ChatDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.chat.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UserCell.self)
        cell.loadUser(byId: viewModel.chat.users[indexPath.row])
        return cell
    }
    
}

extension ChatDetailsViewController: ChatDetailsViewControllerProtocol {
    
}
