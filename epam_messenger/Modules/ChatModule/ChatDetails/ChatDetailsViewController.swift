//
//  ChatDetailsViewController.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 09.04.2020.
//

import UIKit
import Hero
import XLPagerTabStrip
import SDWebImage
import NYTPhotoViewer
import FirebaseAuth

protocol ChatDetailsViewControllerProtocol {
}

class ChatDetailsViewController: UIViewController, ChatDetailsViewControllerProtocol {

    // MARK: - Outlets
    
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var stack: UIStackView!
    @IBOutlet var avatar: AvatarView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var inviteButton: UIButton!
    @IBOutlet var addContactButton: UIButton!
    
    // MARK: - Vars
    
    var tabStrip: ChatDetailsPagerTabStrip!
    var tabStripScrollView: UIScrollView?
    var staticContentHeight: CGFloat!
    
    var viewModel: ChatDetailsViewModelProtocol!
    var chatViewController: ChatViewControllerProtocol?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        staticContentHeight = stack.frame.height
            - UIApplication.safeAreaInsets.top
            - navigationController!.navigationBar.frame.height
        
        setupScroll()
        setupNavigationBar()
        setupAvatar()
        setupInfo()
        
        viewModel.chatGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.setupTabStrip()
        }
    }
    
    private func setupScroll() {
        scroll.delegate = self
    }
    
    private func setupInfo() {
        viewModel.chatModel.listenInfo { [weak self] title, subtitle, _, _ in
            guard let self = self else { return }
            
            self.transitionSubtitleLabel {
                self.titleLabel.text = title
                self.subtitleLabel.text = subtitle
            }
        }
        subtitleLabel.text = "\(viewModel.chatModel.users.count) users"
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
    
    private func setupTabStrip() {
        tabStrip = .init()
        
        let users = ChatDetailsUsersViewController()
        users.router = viewModel.router
        users.updateData(viewModel.chatModel)
        let media = ChatDetailsMediaViewController(
            viewModel: viewModel,
            chatViewController: chatViewController
        )
        media.updateData(viewModel.chatModel)
        
        viewModel.listenChatData { chat in
            guard let chat = chat else { return }
            media.updateData(chat)
            users.updateData(chat)
            self.setupInfo()
            self.setupAvatar()
        }
        
        if case .chat = viewModel.chatModel.type {
            tabStrip.scrollViews.append(users.tableView)
            tabStrip.initialViewControllers.append(users)
        }
        tabStrip.scrollViews.append(media.collectionView)
        tabStrip.initialViewControllers.append(media)
        
        for scrollView in tabStrip.scrollViews {
            scrollView.delegate = self
            scrollView.verticalScrollIndicatorInsets.bottom = UIApplication.safeAreaInsets.bottom
            scrollView.isScrollEnabled = false
        }

        stack.addArrangedSubview(tabStrip.view)
        
        tabStrip.view.height(view.bounds.height
            - UIApplication.safeAreaInsets.top
            - navigationController!.navigationBar.frame.height)
        tabStrip.view.widthToSuperview()
    }
    
    private func setupNavigationBar() {
        let navBar = navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = .init()
        navBar?.isTranslucent = true
        navBar?.barStyle = .black
        navigationController?.view.backgroundColor = .clear

        navigationItem.leftBarButtonItem = .init(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(didCancelTap)
        )
        navigationItem.leftBarButtonItem?.tintColor = UIColor.lightText.withAlphaComponent(1)
        
        switch viewModel.chatModel.type {
        case .personalCorr:
            viewModel.checkContactExists { [weak self] exists, _ in
                guard let self = self else { return }
                if exists ?? false {
                    self.addEditButton()
                }
            }
        case .chat(_, let adminId, _, _):
            if adminId == Auth.auth().currentUser!.uid {
                addEditButton()
            }
        default: break
        }
        
        setupButtons()
    }
    
    private func addEditButton() {
        navigationItem.rightBarButtonItem = .init(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(didEditTap)
        )
        navigationItem.rightBarButtonItem?.tintColor = UIColor.lightText.withAlphaComponent(1)
    }
    
    private func baseSetupButton(_ button: UIButton) {
        button.backgroundColor = .secondary
        button.tintColor = .systemBackground
        button.layer.cornerRadius = 15
    }
    
    private func setupButtons() {
        baseSetupButton(inviteButton)
        baseSetupButton(addContactButton)
        
        switch viewModel.chatModel.type {
        case .personalCorr:
            viewModel.checkContactExists { [weak self] exists, _ in
                guard let self = self else { return }
                if !(exists ?? false) {
                    self.addContactButton.isHidden = false
                    self.addContactButton.zoomIn()
                }
            }
        case .chat(_, let adminId, _, _):
            inviteButton.isHidden = adminId != Auth.auth().currentUser!.uid
        default: break
        }
    }
    
    private func setupAvatar() {
        avatar.top(to: view, priority: .defaultHigh)
        let gradient = CAGradientLayer()
        var bounds = avatar!.bounds
        bounds.size.height = 100
        gradient.frame = bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.5).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        avatar.layer.addSublayer(gradient)
        
        switch viewModel.chatModel.type {
        case .personalCorr:
            viewModel.listenUserData { [weak self] user in
                guard let self = self, let user = user else { return }
                self.avatar.setup(
                    withUser: user,
                    roundCorners: false
                )
            }
        case .chat(let chatData):
            avatar.setup(
                withChat: chatData,
                avatarRef: viewModel.chatModel.avatarRef,
                roundCorners: false
            )
        default: break
        }
    }
    
    // MARK: - Actions

    @IBAction func didInviteTap(_ sender: UIButton) {
        viewModel.inviteUser()
    }
    
    @IBAction func didAddContactTap(_ sender: Any) {
        viewModel.addContact { [weak self] err in
            guard let self = self else { return }
            if let err = err {
                self.presentErrorAlert(err.localizedDescription)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.addContactButton.alpha = 0
                }) { _ in
                    self.addContactButton.isHidden = true
                }
                self.addEditButton()
            }
        }
    }
    
    @objc func didCancelTap() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func didEditTap() {
        if scroll.contentOffset.y == 0 {
            viewModel.showChatEdit()
        }
    }
}

extension ChatDetailsViewController: UIScrollViewDelegate {
    
    private func animateNavBarStyle(_ barStyle: UIBarStyle) {
        let navBar = navigationController?.navigationBar
        if navBar?.barStyle != barStyle {
            UIView.animate(withDuration: 0.2, animations: {
                navBar?.barStyle = barStyle
            })
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let tabStripViewController = tabStrip.scrollViews[tabStrip.currentIndex]
        
        switch scrollView {
        case scroll:
            if yOffset >= staticContentHeight {
                scroll.isScrollEnabled = false
                for viewController in tabStrip.scrollViews {
                    viewController.isScrollEnabled = true
                }
            }
            
            let yOffsetScale: CGFloat =
                (yOffset < 0
                    ? 0 :
                        yOffset > staticContentHeight
                        ? staticContentHeight
                    : yOffset
                ) / staticContentHeight
            
            let container = titleLabel.superview!
            let absLeft = container.superview!.convert(container.frame.origin, to: nil).x
            titleLabel.transform = .init(
                translationX: yOffsetScale * (
                    stack.bounds.width / 2
                        - absLeft
                        - titleLabel.frame.width / 2
                ),
                y: 0
            )
            
            subtitleLabel.transform = .init(
                translationX: yOffsetScale * (
                    stack.bounds.width / 2
                        - absLeft
                        - subtitleLabel.frame.width / 2
                ),
                y: 0
            )
            
            let buttonsTransform = CGAffineTransform(
                scaleX: (1 - yOffsetScale),
                y: (1 - yOffsetScale)
            )
            inviteButton.transform = buttonsTransform
            addContactButton.transform = buttonsTransform
            
            avatar.layer.opacity = Float(1 - yOffsetScale)
            navigationItem.leftBarButtonItem?.tintColor = UIColor.blend(
                color1: UIColor.lightText.withAlphaComponent(1), intensity1: 1 - yOffsetScale,
                color2: .accent, intensity2: yOffsetScale
            )
            navigationItem.rightBarButtonItem?.tintColor = UIColor.blend(
                color1: UIColor.lightText.withAlphaComponent(1), intensity1: 1 - yOffsetScale,
                color2: .clear, intensity2: yOffsetScale
            )
            
            animateNavBarStyle(yOffsetScale > 0.5 ? .default : .black)
            
        case tabStripViewController:
            if yOffset <= 0 {
                scroll.isScrollEnabled = true
                for viewController in tabStrip.scrollViews {
                    viewController.isScrollEnabled = false
                }
            }
        default: break
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        switch scrollView {
        case scroll:
            completeScrollAnimation(
                scrollView: scrollView,
                bottomBound: 0,
                topBound: staticContentHeight
            )
        default: break
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        switch scrollView {
        case scroll:
            completeScrollAnimation(
                scrollView: scrollView,
                bottomBound: 0,
                topBound: staticContentHeight
            )
        default: break
        }
    }
    
    private func completeScrollAnimation(
        scrollView: UIScrollView,
        bottomBound: CGFloat,
        topBound: CGFloat
    ) {
        let yOffset = scrollView.contentOffset.y
        if offsetInBounds(yOffset, min: bottomBound, max: bottomBound + topBound / 2) {
            scrollView.setContentOffset(.init(x: 0, y: bottomBound), animated: true)
        } else if offsetInBounds(yOffset, min: bottomBound + topBound / 2, max: topBound) {
            scrollView.setContentOffset(.init(x: 0, y: topBound), animated: true)
        }
    }
    
    private func offsetInBounds(_ offset: CGFloat, min: CGFloat, max: CGFloat) -> Bool {
        return offset > min && offset < max
    }
    
}
