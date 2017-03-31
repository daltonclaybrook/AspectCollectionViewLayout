//
//  AspectCollectionViewLayout.swift
//  AspectCollectionView
//
//  Created by Dalton Claybrook on 3/30/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

protocol AspectLayoutDataSource: class {
    func aspectLayout(_ layout: AspectCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}

class AspectCollectionViewLayout: UICollectionViewLayout {
    
    weak var dataSource: AspectLayoutDataSource?
    private var cellAttributes = [UICollectionViewLayoutAttributes]()
    var numberOfColumns = 2 { didSet { invalidateLayout() } }
    var cellPadding: CGFloat = 4.0 { didSet { invalidateLayout() } }
    
    //MARK: Init
    
    init(dataSource: AspectLayoutDataSource) {
        self.dataSource = dataSource
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Superclass
    
    override func prepare() {
        super.prepare()
        updateCellFrames()
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView,
            let height = cellAttributes.sorted(by: { $0.frame.maxY > $1.frame.maxY }).first?.frame.maxY else { return .zero }
        
        return CGSize(width: collectionView.bounds.width, height: height + cellPadding)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttributes.filter { rect.contains($0.frame) || rect.intersects($0.frame) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributes[indexPath.item]
    }
    
    //MARK: Private
    
    private func updateCellFrames() {
        guard numberOfColumns > 0,
            let dataSource = dataSource,
            let collectionView = collectionView,
            collectionView.numberOfSections > 0 else { return }
        
        var cellFrames = [CGRect]()
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        var currentColumnHeights = (0..<numberOfColumns).map { _ in CGFloat(0.0) }
        let columnWidth = (collectionView.bounds.width - cellPadding * CGFloat(numberOfColumns+1)) / CGFloat(numberOfColumns)
        
        for idx in (0..<numberOfItems) {
            let size = dataSource.aspectLayout(self, sizeForItemAt: IndexPath(item: idx, section: 0))
            let cellHeight = size.height * columnWidth / size.width
            let column = nextColumn(withColumnHeights: currentColumnHeights)
            let columnHeight = currentColumnHeights[column]
            let xOffset = (cellPadding + columnWidth) * CGFloat(column) + cellPadding
            let yOffset = columnHeight + cellPadding
            let frame = CGRect(x: xOffset, y: yOffset, width: columnWidth, height: cellHeight)
            currentColumnHeights[column] = columnHeight + cellPadding + cellHeight
            cellFrames.append(frame)
        }
        
        self.cellAttributes = cellFrames.enumerated().map { offset, cellFrame in
            let indexPath = IndexPath(item: offset, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = cellFrame
            return attributes
        }
    }
    
    private func nextColumn(withColumnHeights heights: [CGFloat]) -> Int {
        var shortestColumn = 0
        var shortestHeight = CGFloat.greatestFiniteMagnitude
        for (idx, height) in heights.enumerated() {
            if height < shortestHeight {
                shortestColumn = idx
                shortestHeight = height
            }
        }
        return shortestColumn
    }
}
