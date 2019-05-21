//
//  URIHelper.swift
//  UdemyClone
//
//  Created by  Hoan  vu on 10/17/16.
//  Copyright © 2016 HoanVu. All rights reserved.

import UIKit

import UserNotifications



class MyAlertController: NSObject {

   
    
    static func showAlert(title:String = "THÔNG BÁO",message:String,handler:(() -> ())? = nil) {
        
        let myAlert = LimoAlertView(title: title, message: message)
        myAlert.positvieAction(title: "ĐÓNG") {
            if let h = handler {
                h()
            }
        }
        myAlert.show()
    }
    
    static func showAlertExpriedToken(title: String = "THÔNG BÁO", message: String, handlerPositive: (() -> Void)?, handlerNegative: (() -> Void)?) {
        let myAlert = LimoAlertView(title: title, message: message)
        myAlert.positvieAction(title: "ĐÓNG") {
            if let h = handlerPositive {
                h()
            }
        }
        myAlert.negativeAction(title: "Đăng Nhập") {
            if let h = handlerNegative {
                h()
            }
        }
        
        myAlert.show()
    }
    
    static func showAlertTwoOption(title: String = "THÔNG BÁO", message: String, handlerPositive: (() -> Void)?, handlerNegative: (() -> Void)?) {
        let myAlert = LimoAlertView(title: title, message: message)
        myAlert.positvieAction(title: "ĐÓNG") {
            if let h = handlerPositive {
                h()
            }
        }
        myAlert.negativeAction(title: "OK") {
            if let h = handlerNegative {
                h()
            }
        }
        
        myAlert.show()
    }
}
extension CGRect {
    
    
    var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            
            self = CGRect(x: newValue, y: self.y, width: self.width, height: self.height)
        }
    }
    
    var y: CGFloat {
        get {
            return self.origin.y
        }
        set {
            
            self = CGRect(x: self.x, y: newValue, width: self.width, height: self.height)
        }
    }
    
    var width: CGFloat {
        get {
            return self.size.width
        }
        set {
            
            self = CGRect(x: self.x, y: self.y, width: newValue, height: self.height)
        }
    }
    
    var height: CGFloat {
        get {
            return self.size.height
        }
        set {
            
            
            self = CGRect(x: self.x, y: self.y, width: self.width, height: newValue)
            
        }
    }
    
    
    var top: CGFloat {
        get {
            return self.origin.y
        }
        set {
            y = newValue
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.origin.y + self.size.height
        }
        set {
            
            self = CGRect(x: self.x, y: newValue - height, width: self.width, height: height)
        }
    }
    
    var left: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self.x = newValue
        }
    }
    
    var right: CGFloat {
        get {
            return x + width
        }
        set {
            
            self = CGRect(x: newValue - width, y: y, width: self.width, height: height)
            
        }
    }
    
    
    var midX: CGFloat {
        get {
            return self.x + self.width / 2
        }
        set {
            
            self = CGRect(x: newValue - width / 2, y: y, width: self.width, height: height)
            
        }
    }
    
    var midY: CGFloat {
        get {
            return self.y + self.height / 2
        }
        set {
            
            self = CGRect(x: x, y: newValue - height / 2, width: self.width, height: height)
            
        }
    }
    
    
    var center: CGPoint {
        get {
            
            
            return CGPoint(x: self.midX, y: self.midY)
        }
        set {
            
            self = CGRect(x: newValue.x - width / 2, y: newValue.y - height / 2, width: width, height: height)
        }
    }
}
