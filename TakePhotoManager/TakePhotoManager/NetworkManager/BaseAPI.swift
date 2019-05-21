//
//  BaseAPI.swift
//  RealEstate_AR-VR
//
//  Created by DangHung on 1/4/18.
//  Copyright © 2018 VASTbit. All rights reserved.
//

import Foundation
import Alamofire

enum APIPath {
    case getNotification(page: String)
    case getNumberNoti
    
    var path: String {
        switch self {
        case .getNotification(let page):
            return "notifications?page=\(page)"
        case .getNumberNoti:
            return "total-notify-not-read"
       
        }           
    }
}

