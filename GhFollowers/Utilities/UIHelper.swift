//
//  UIHelper.swift
//  GhFollowers
//
//  Created by Rami Elwan on 12.03.24.
//

import UIKit

class UIHelper {
    static func createThreeColumnFlowLayout(width: CGFloat) -> UICollectionViewFlowLayout {
        let padding: CGFloat = 12
        let gap: CGFloat = 10
        let cellWidth = (width - (2 * padding) - (2 * gap))/3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth + 40)
        
        return flowLayout
    }
}
