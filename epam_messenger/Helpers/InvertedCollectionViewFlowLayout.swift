//
//  InvertedCollectionViewFlowLayout.swift
//  epam_messenger
//
//  Created by Nickolay Truhin on 09.03.2020.
//

import UIKit

class InvertedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    // inverting the transform in the layout, rather than directly on the cell,
    // is the only way I've found to prevent cells from flipping during animated
    // cell updates

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.layoutAttributesForItem(at: indexPath)
        attrs?.transform = CGAffineTransform(scaleX: 1, y: -1)
        return attrs
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attrsList = super.layoutAttributesForElements(in: rect)
        if let list = attrsList {
            for i in 0..<list.count {
                list[i].transform = CGAffineTransform(scaleX: 1, y: -1)
            }
        }
        return attrsList
    }
}
