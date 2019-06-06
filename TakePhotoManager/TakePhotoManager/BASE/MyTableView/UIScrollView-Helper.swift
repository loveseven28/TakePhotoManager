//
//  File.swift
//  SExpress
//
//  Created by Mac Mini on 3/30/18.
//  Copyright © 2018 HoanVu. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
    var isAtTop : Bool {
        
        return contentOffset.y == verticalOffsetForTop
        
    }
    
    var isAtBottom : Bool {
        
        return contentOffset.y >= verticalOffsetForBottom
        
    }
    
    var isAtRight: Bool {
        return contentOffset.x == horizontalOffsetForRight
    }
    
    var verticalOffsetForTop : CGFloat {
        
        let topInset = contentInset.top
        return -topInset
        
    }
    
    var verticalOffsetForBottom : CGFloat {
        
        let scrollViewHeight = bounds.size.height
        let contentHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = contentHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
        
    }
    
    var horizontalOffsetForRight : CGFloat {
        
        let scrollViewWidth = bounds.size.width
        let contentWidth = contentSize.width
        let WidthInset = contentInset.right
        let scrollViewWidthOffset = contentWidth + WidthInset - scrollViewWidth
        return scrollViewWidthOffset
    }
    
}
