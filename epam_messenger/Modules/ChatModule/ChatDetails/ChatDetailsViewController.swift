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

protocol ChatDetailsViewControllerProtocol {
    
}

class ChatDetailsViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var stack: UIStackView!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    // MARK: - Vars
    
    var tabStrip: ChatDetailsPagerTabStrip!
    var tabStripScrollView: UIScrollView?
    var staticContentHeight: CGFloat!
    
    var viewModel: ChatDetailsViewModelProtocol!
    
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
    
    private func setupTabStrip() {
        tabStrip = .init()
        
        let first = ChatDetailsUsersViewController()
        (first.tableView as UIScrollView).delegate = self
        let second = ChatDetailsUsersViewController()
        (second.tableView as UIScrollView).delegate = self
        let third = ChatDetailsUsersViewController()
        (third.tableView as UIScrollView).delegate = self
        tabStrip.initialViewControllers = [ first, second, third ]

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
        
        let ref = viewModel.chat.avatarRef
        var path = ref.fullPath
        path.insert(contentsOf: "_200x200", at: path.index(path.endIndex, offsetBy: -4))
        let cacheKey = "gs://\(ref.bucket)/\(path)"
        
        avatarImage.sd_setImage(
            with: viewModel.chat.avatarRef,
            placeholderImage: SDImageCache.shared.imageFromDiskCache(forKey: cacheKey) ?? #imageLiteral(resourceName: "logo")
        )
    }

    @objc func didCancelTap() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension ChatDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        let tabStripViewController = tabStrip.initialViewControllers[tabStrip.currentIndex].tableView!
        
        switch scrollView {
        case scroll:
            if yOffset >= staticContentHeight {
                scroll.isScrollEnabled = false
                for viewController in tabStrip.initialViewControllers {
                    viewController.tableView.isScrollEnabled = true
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
            
        case tabStripViewController:
            if yOffset <= 0 {
                scroll.isScrollEnabled = true
                for viewController in tabStrip.initialViewControllers {
                    viewController.tableView.isScrollEnabled = false
                }
            }
        default: break
        }
    }
}

extension ChatDetailsViewController: ChatDetailsViewControllerProtocol {
    
}
