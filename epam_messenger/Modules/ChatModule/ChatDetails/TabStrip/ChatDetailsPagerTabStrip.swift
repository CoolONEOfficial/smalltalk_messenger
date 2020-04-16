//
//  ChatDetailsPagerTabStrip.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 10.04.2020.
//

import UIKit
import XLPagerTabStrip

class ChatDetailsPagerTabStrip: ButtonBarPagerTabStripViewController {
    
    var initialViewControllers: [UIViewController] = []
    var scrollViews: [UIScrollView] = []
    
    override func viewDidLoad() {
        pagerBehaviour = .progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: true)
        
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .plainText
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemTitleColor = .red
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14, weight: .semibold)
        
        super.viewDidLoad()
        
        buttonBarView.selectedBar.layer.cornerRadius = 4
        buttonBarView.selectedBar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        self.changeCurrentIndexProgressive = didChangeCurrentIndex
    }
    
    private func didChangeCurrentIndex(
        oldCell: ButtonBarViewCell?,
        newCell: ButtonBarViewCell?,
        progressPercentage: CGFloat,
        changeCurrentIndex: Bool,
        animated: Bool
    ) {
        let first: UIColor = .plainText
        let second: UIColor = .secondaryLabel
        oldCell?.label.textColor = UIColor.blend(
            color1: progressPercentage > 0.5 ? first : second, intensity1: 1.0 - progressPercentage,
            color2: progressPercentage > 0.5 ? second : first, intensity2: progressPercentage
        )
        newCell?.label.textColor = UIColor.blend(
            color1: progressPercentage > 0.5 ? second : first, intensity1: 1.0 - progressPercentage,
            color2: progressPercentage > 0.5 ? first : second, intensity2: progressPercentage
        )
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        initialViewControllers
    }
}
