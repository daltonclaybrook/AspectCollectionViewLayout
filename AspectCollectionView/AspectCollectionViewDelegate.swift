//
//  AspectCollectionViewLayout.swift
//  AspectCollectionView
//
//  Created by Dalton Claybrook on 3/29/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

protocol AspectDataSource: class {
    func sizeForImage(atIndexPath indexPath: IndexPath) -> CGSize
}

class AspectCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    weak var dataSource: AspectDataSource?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width / 2.0
        guard let imageSize = dataSource?.sizeForImage(atIndexPath: indexPath) else { return CGSize(width: cellWidth, height: 50) }
        let cellHeight = imageSize.height * cellWidth / imageSize.width
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
