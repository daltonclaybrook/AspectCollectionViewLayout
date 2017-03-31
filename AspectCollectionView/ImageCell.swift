//
//  ImageCell.swift
//  AspectCollectionView
//
//  Created by Dalton Claybrook on 3/29/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit
import Kingfisher

class ImageCell: UICollectionViewCell {
    static var reuseID: String {
        return "ImageCell"
    }
    
    @IBOutlet var imageView: UIImageView!
    
    func configure(withURL url: URL) {
        imageView.kf.setImage(with: url)
    }
}
