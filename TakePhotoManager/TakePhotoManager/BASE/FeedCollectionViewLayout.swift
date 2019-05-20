//
//  FeedCollectionViewLayout.swift
//  KaraKid
//
//  Created by Vuong Nguyen on 11/18/17.
//  Copyright © 2017 VASTbit. All rights reserved.
//

import UIKit

class FeedCollectionViewLayout: UICollectionViewLayout {
    
    fileprivate let numberOfColumns: Int = 2
    fileprivate let cellPadding: CGFloat = 2
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0
    
    var isPullToRefresh: Bool = false
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        self.cache.removeAll()
        guard let collectionView = collectionView else { return }
        if isPullToRefresh {
            contentHeight = 0
            cache = []
        }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(columnWidth * CGFloat(column))
        }
        
        var xOffset1 = [CGFloat]()
        for column in 0 ..< 3 {
            xOffset1.append((contentWidth / 3) * CGFloat(column))
        }
        
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        var yOffset1 = [CGFloat](repeating: 123 * 3, count: 3)
        
        
        let width3Column = contentWidth / 3
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            var originX: CGFloat = 0
            var width: CGFloat = 0
            var originY: CGFloat = 0
            let height: CGFloat = 123
            
            if indexPath.row < 6 {
                switch indexPath.item {
                case 0:
                    originX = 0
                case 1:
                    originX = contentWidth * 0.4
                case 2:
                    originX = 0
                case 3:
                    originX = contentWidth * 0.6
                case 4:
                    originX = 0
                case 5:
                    originX = contentWidth * 0.4
                default:
                    originX = xOffset[column]
                }
                
                switch indexPath.item {
                case 0:
                    width = contentWidth * 0.4
                case 1:
                    width = contentWidth * 0.6
                case 2:
                    width = contentWidth * 0.6
                case 3:
                    width = contentWidth * 0.4
                case 4:
                    width = contentWidth * 0.4
                case 5:
                    width = contentWidth * 0.6
                default:
                    width = contentWidth / 2
                }
                
                switch indexPath.item {
                case 0:
                    originY = 0
                case 1:
                    originY = 0
                case 2:
                    originY = yOffset[1]
                case 3:
                    originY = yOffset[0] - height
                default:
                    originY = yOffset[column]
                }
                
                let frame = CGRect(x: originX, y: originY, width: width, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attribute.frame = insetFrame
                cache.append(attribute)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] += height
                
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            } else {
               
                originX = xOffset1[column]
                width = width3Column
                originY = yOffset1[column]
                
                let frame = CGRect(x: originX, y: originY, width: width, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attribute.frame = insetFrame
                cache.append(attribute)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset1[column] += height
                
                column = column < (3 - 1) ? (column + 1) : 0
            }
            
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attr in cache {
           
            
            if !(attr.representedElementKind == UICollectionView.elementKindSectionHeader
                || attr.representedElementKind == UICollectionView.elementKindSectionFooter) {
                
                // cells will be customise here, but Header and Footer will have layout without changes.
                if attr.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attr)
                }
            }

        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            
        case UICollectionView.elementKindSectionFooter:
            break
        default:
            break
        }
        
        return UICollectionViewLayoutAttributes()
    }
    

}

