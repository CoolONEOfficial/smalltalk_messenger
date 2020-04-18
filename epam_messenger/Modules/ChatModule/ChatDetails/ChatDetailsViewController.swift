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

protocol ChatDetailsViewControllerProtocol {
}

class ChatDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var stack: UIStackView!
    @IBOutlet var avatarImage: AvatarView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    // MARK: - Vars
    
    var tabStrip: ChatDetailsPagerTabStrip!
    var tabStripScrollView: UIScrollView?
    var staticContentHeight: CGFloat!
    
    var viewModel: ChatDetailsViewModelProtocol!
    var chatViewController: ChatViewControllerProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        staticContentHeight = stack.frame.height
            - UIApplication.safeAreaInsets.top
            - navigationController!.navigationBar.frame.height
        
        setupScroll()
        setupNavigationBar()
        setupAvatar()
        setupTabStrip()
        setupInfo()
    }
    
    private func setupScroll() {
        scroll.delegate = self
    }
    
    private func setupInfo() {
        viewModel.chat.loadInfo { [weak self] title, subtitle, placeholderText, placeholderColor in
            guard let self = self else { return }
            
            self.transitionSubtitleLabel {
                self.titleLabel.text = title
                self.subtitleLabel.text = subtitle
            }
            
            if let placeholderText = placeholderText {
                self.avatarImage.setup(
                    withRef: self.viewModel.chat.avatarRef,
                    text: placeholderText,
                    color: placeholderColor ?? .accent,
                    roundCorners: false
                )
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
    
    private func setupTabStrip() {
        tabStrip = .init()
        
        let users = ChatDetailsUsersViewController()
        users.updateData(viewModel.chat)
        let media = ChatDetailsMediaViewController(
            viewModel: viewModel,
            chatViewController: chatViewController
        )
        media.updateData(viewModel.chat)
        
        if case .chat = viewModel.chat.type {
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
    
    private func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    private func setupNavigationBar() {
        let navBar = navigationController?.navigationBar
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = .init()
        navBar?.isTranslucent = true
        navigationController?.view.backgroundColor = .clear

        navigationItem.leftBarButtonItem = .init(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(didCancelTap)
        )
        navigationItem.leftBarButtonItem?.tintColor = UIColor.lightText.withAlphaComponent(1)
    }
    
    private func setupAvatar() {
        avatarImage.top(to: view, priority: .defaultHigh)
        let gradient = CAGradientLayer()
        var bounds = avatarImage!.bounds
        bounds.size.height = 100
        gradient.frame = bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.5).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        avatarImage.layer.addSublayer(gradient)
    }

    @objc func didCancelTap() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension ChatDetailsViewController: UIScrollViewDelegate {
    
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
            
            titleLabel.transform = .init(
                translationX: yOffsetScale * (stack.bounds.width / 2 - titleLabel.frame.width / 2),
                y: 0
            )
            subtitleLabel.transform = .init(
                translationX: yOffsetScale * (stack.bounds.width / 2 - subtitleLabel.frame.width / 2),
                y: 0
            )
            avatarImage.layer.opacity = Float(1 - yOffsetScale)
            navigationItem.leftBarButtonItem?.tintColor = UIColor.blend(
                color1: UIColor.lightText.withAlphaComponent(1), intensity1: 1 - yOffsetScale,
                color2: .accent, intensity2: yOffsetScale
            )
            
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

extension ChatDetailsViewController: ChatDetailsViewControllerProtocol {
    
}
