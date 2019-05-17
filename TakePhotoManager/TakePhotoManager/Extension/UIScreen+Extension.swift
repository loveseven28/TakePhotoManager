//
//  UIScreen+Extension.swift
//  TTS
//
//  Created by mac mini on 1/25/19.
//  Copyright © 2019 mac mini. All rights reserved.
//

import Foundation
import UIKit

extension UIScreen {
    
    func widthOfSafeArea() -> CGFloat {
        
        guard let rootView = UIApplication.shared.keyWindow else { return 0 }
        
        if #available(iOS 11.0, *) {
            
            let leftInset = rootView.safeAreaInsets.left
            
            let rightInset = rootView.safeAreaInsets.right
            
            return rootView.bounds.width - leftInset - rightInset
            
        } else {
            
            return rootView.bounds.width
            
        }
        
    }
    
    func heightOfSafeArea() -> CGFloat {
        
        guard let rootView = UIApplication.shared.keyWindow else { return 0 }
        
        if #available(iOS 11.0, *) {
            
            let topInset = rootView.safeAreaInsets.top
            
            let bottomInset = rootView.safeAreaInsets.bottom
            
            return rootView.bounds.height - topInset - bottomInset
            
        } else {
            
            return rootView.bounds.height
            
        }
        
    }
    
    func heightBottomSafeArea() -> CGFloat {
        guard let rootView = UIApplication.shared.keyWindow else { return 0 }
        
        if #available(iOS 11.0, *) {
            let bottomInset = rootView.safeAreaInsets.bottom
            return bottomInset
            
        } else {
            
            return rootView.bounds.height
            
        }
    }
    
    func heightTopSafeArea() -> CGFloat {
        guard let rootView = UIApplication.shared.keyWindow else { return 0 }
        
        if #available(iOS 11.0, *) {
            let topInset = rootView.safeAreaInsets.top
            return topInset
            
        } else {
            return rootView.bounds.height
            
        }
    }
    
}
