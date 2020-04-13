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

fileprivate extension UIColor {
    static func blend(color1: UIColor, intensity1: CGFloat = 0.5, color2: UIColor, intensity2: CGFloat = 0.5) -> UIColor {
        let total = intensity1 + intensity2
        let l1 = intensity1/total
        let l2 = intensity2/total
        guard l1 > 0 else { return color2}
        guard l2 > 0 else { return color1}
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2)
    }
}
