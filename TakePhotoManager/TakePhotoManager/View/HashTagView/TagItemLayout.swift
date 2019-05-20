//
//  CategoryItemLayout.swift
//  Sale
//
//  Created by Mac Mini on 10/17/17.
//  Copyright © 2017 thach.tran. All rights reserved.
//

import UIKit

protocol TagItemLayoutDelegate {
    func textForIndexPath(index:IndexPath) -> String?
    func prepareAttributeFrameDone()
}

class TagItemLayout: UICollectionViewLayout {

    var cache:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    var contentSizeHeight:CGFloat = 0
    var contentSizeWidth:CGFloat = 0
    var delegate:TagItemLayoutDelegate?
    var itemHeight:CGFloat = 38
  
    private let leftPadding = CGFloat(10)
    private let rightPadding = CGFloat(10)
    
    override func prepare() {
        
        cache.removeAll() // clear cache
            var i  = 0
        if let cv = collectionView {
            
            let items = cv.numberOfItems(inSection: 0)
            contentSizeWidth = cv.frame.width - (rightPadding + leftPadding)
            var xOffset:CGFloat = 0
            var yOffset:CGFloat = 0
            
            var totalHeight:CGFloat = 38
            
            for item in 0..<items {
                
                i += 1
                var itemWidth:CGFloat = 100
                let indexPath = IndexPath(row: item, section: 0)
                
                let tagText = self.delegate?.textForIndexPath(index: indexPath)
                if let text = tagText {
                    itemWidth = text.widthOfString(usingFont: UIFont.systemFont(ofSize: 14)) + 50
                }
                
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                var frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
               
                
                if xOffset + itemWidth < contentSizeWidth {
                    xOffset += itemWidth
                }else {
                    xOffset = 0
                    yOffset += itemHeight
                    frame.origin = CGPoint(x: xOffset, y: yOffset)
                    xOffset += itemWidth
                }
                totalHeight = yOffset + itemHeight
                attribute.frame = frame
                self.cache.append(attribute)
            }
            contentSizeHeight = totalHeight
            self.delegate?.prepareAttributeFrameDone()
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cache[indexPath.row]
    }
    
    override var collectionViewContentSize: CGSize {
        
        let size = CGSize(width: collectionView?.frame.width ?? 0, height: contentSizeHeight)
        return size
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return !newBounds.size.equalTo(self.collectionView!.frame.size)
    }
}
