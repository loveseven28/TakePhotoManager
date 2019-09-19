//
//  UIStoryboard+Extension.swift
//  VLC
//
//  Created by mac mini on 8/23/18.
//  Copyright © 2018 mac mini. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    class func storyboardWithName(name:String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle:  Bundle.main)
    }
    
    class func chatViewController() -> ChatVC {
        return UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: ChatVC.nib) as! ChatVC
    }
    
    
}
