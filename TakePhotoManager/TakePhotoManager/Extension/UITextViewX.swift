//
//  UITextViewX.swift
//  SExpress
//
//  Created by Mac Mini on 4/4/18.
//  Copyright © 2018 HoanVu. All rights reserved.
//

import Foundation
import UIKit

class UITextViewX:UITextView {
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
