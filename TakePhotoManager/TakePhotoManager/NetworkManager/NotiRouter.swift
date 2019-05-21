//
//  NotiRouter.swift
//  TTS
//
//  Created by mac mini on 3/29/19.
//  Copyright © 2019 mac mini. All rights reserved.
//

import Foundation
import Alamofire

enum NotiRouter: APIRouter {
    case getNotification(header: HTTPHeaders, page: String)
    case getNumberNoti(header: HTTPHeaders)
    var params: Params {
        switch self {
        case .getNotification(_, _):
            return nil
        case .getNumberNoti(_):
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNotification(_, _):
            return .get
        case .getNumberNoti(_):
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getNotification(_, let page):
            return AppURL.Domain + APIPath.getNotification(page: page).path
        case .getNumberNoti(_):
            return AppURL.Domain + APIPath.getNumberNoti.path
        }
    }
}

extension NetworkManager {
    public func getNotification(page: String, completion: @escaping(DataModel<DataLoadMore<NotiModel>>?, Error?) -> Void) {
        myRequest(router: NotiRouter.getNotification(header: [:], page: page)) { [weak self] (response, error) in
            guard let `self` = self else { return }
            if let value = response {
                let result: (DataModel<DataLoadMore<NotiModel>>?, Error?) = self.decodableToObject(response: value)
                completion(result.0, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    public func getNumberNoti(completion: @escaping(DataModel<Int>?, Error?) -> Void) {
        myRequest(router: NotiRouter.getNumberNoti(header: [:])) { [weak self] (response, error) in
            guard let `self` = self else { return }
            if let value = response {
                let result: (DataModel<Int>?, Error?) = self.decodableToObject(response: value)
                completion(result.0, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
}
