//
//  Settings.swift
//  VLC
//
//  Created by mac mini on 8/31/18.
//  Copyright © 2018 mac mini. All rights reserved.
//

import Foundation
import UIKit

class SettingsApp : NSObject {
    private static let kSettingToken = "token"
    private static let kSettingDeviceToken = "deviceToken"
    private static let kUserID = "userId"
    private static let kUserInfo = "kUserInfo"
    private static let kLocation = "kLocation"
    
    static var token: String? {
        get {
            return UserDefaults.standard.value(forKey: kSettingToken) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kSettingToken)
        }
    }
    
    static var deviceToken: String? {
        get {
            return UserDefaults.standard.value(forKey: kSettingDeviceToken) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kSettingDeviceToken)
        }
    }
    
    static var userID: String? {
        get {
            return UserDefaults.standard.value(forKey: kUserID) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: kUserID)
        }
    }
    
    static var isUserLogged: Bool? {
        get {
            return UserDefaults.standard.value(forKey: AppKey.kLogged_in.rawValue) as? Bool
        }
        set {
            UserDefaults.standard.set(newValue, forKey: AppKey.kLogged_in.rawValue)
        }
    }
    
//    static var UserInfo: UserModel? {
//        get {
//            if let data = UserDefaults.standard.value(forKey: "userInfo") as? Data {
//                let userData = try? PropertyListDecoder().decode(UserModel.self, from: data)
//                return userData
//            }
//            return nil
//        } set {
//            return UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "userInfo")
//        }
//    }
//
    static var totalCartNumber: Int {
        get {
            return UserDefaults.standard.value(forKey: "numberCart") as? Int ?? 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "numberCart")
        }
    }
    
    static func checkUserLogin() -> Bool {
        if let login = isUserLogged {
            if login {
                return true
            }
            return false
        } else {
            return false
        }
        
    }
    
}
