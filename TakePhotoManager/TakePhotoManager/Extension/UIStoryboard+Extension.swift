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
    
//    class func homeViewController() -> HomeViewController {
//        return UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: HomeViewController.nib) as! HomeViewController
//    }
    
    
}
