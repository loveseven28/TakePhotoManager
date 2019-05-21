//
//  NetworkManager.swift
//  RealEstate_AR-VR
//
//  Created by Vuong Nguyen on 12/26/17.
//  Copyright © 2017 VASTbit. All rights reserved.
//

import Foundation
import Alamofire


protocol APIRouter: URLRequestConvertible {
    
    var params : Params { get }
    var method : HTTPMethod { get }
    var path : String { get }
}

extension APIRouter {
    
    public func asURLRequest() throws -> URLRequest {
        let baseURL = URL(string: path)!
        var request = URLRequest(url: baseURL)
        request.httpMethod = method.rawValue
        request.timeoutInterval = AppURL.timeOut
        return try JSONEncoding.default.encode(request, with: params)
    }
    
}

struct AppURL {
    
    static let Domain = "http://chotot.hoanvusolutions.com.vn/api/v1/"
    static let timeOut: Double = 60
}

typealias Params = [String: Any]?

let NETWORK_MANAGER = NetworkManager.shared

class NetworkManager:SwiftDecoder {
    
    public static let shared = NetworkManager()

    internal func request(_ router: APIRouter) -> DataRequest {
        do {
           let header = self.buildRequestHeader()
            var urlRequest = try router.asURLRequest()
            urlRequest.allHTTPHeaderFields = header
            let request = Alamofire.request(urlRequest)
            return request
        }
        catch _ {
            fatalError("Router request have a problem! \(router)")
        }
    }
    
    fileprivate func buildRequestHeader() -> HTTPHeaders {
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        if let token = SettingsApp.token {
            headers["Authorization"] =  "Bearer " + token
        }
        return headers
    }
    
    func myRequest(router: APIRouter,completionBlock:@escaping (_ data: Any?, Error?)->()) {
        request(router).responseJSON {[weak self] (response) in
            guard let `self` = self else { return }
            
            let rs = self.handleStatusCodeValidation(response)
            switch rs {
            case .failure(let error):
                completionBlock(nil, error)
                if error.localizedDescription == NetworkResponseError.authenticationError.localizedDescription {
                    self.handleTokenExpỉed()
                }
            case .success:
                if let json = response.result.value as? [String: Any] {
                    let status = json["status"] as? Int
                    if status == 401 {
                        if SettingsApp.token != nil {
                            self.handleTokenExpỉed()
                        }
                        return
                    }
                }
                completionBlock(response.result.value, nil)
            }
        }
    }
    
    func handleStatusCodeValidation(_ dataReponse: DataResponse<Any>?) -> ResultStatusCode<NetworkResponseError> {
        
        guard let uwrDataResponse = dataReponse, let uwrResponse = uwrDataResponse.response else {
            return .failure(NetworkResponseError.failed)
        }
        switch uwrResponse.statusCode {
        case 200...299, 422, 404:
            return .success
        case 401:
            return .failure(NetworkResponseError.authenticationError)
        case 501...599:
            return .failure(NetworkResponseError.badRequest)
        case 600:
            return .failure(NetworkResponseError.outdated)
        default:
            return .failure(NetworkResponseError.failed)
        }
    }

}

extension NetworkManager {
    
    func logout() {
        SettingsApp.token = nil
        UIApplication.shared.applicationIconBadgeNumber = 0
        let ud = UserDefaults.standard
        ud.removeObject(forKey: "token")
        ud.synchronize()
    }
    
    func handleTokenExpỉed() {
        if SettingsApp.token == nil {
            SettingsApp.token = nil
            MyAlertController.showAlert(title: "Thông Báo", message: "Vui lòng đăng nhập để sử dụng tính năng này.", handler: {
//                let loginVC = UIStoryboard.loginVC()
//                if let topview = UIWindow.topViewController() {
//                    topview.present(loginVC, animated: true, completion: nil)
//                }
            })
        } else {
            SettingsApp.token = nil
            MyAlertController.showAlert(title: "Thông Báo", message: "Phiên làm việc của bạn đã hết hạn. Vui lòng đăng nhập lại", handler: {
//                let loginVC = UIStoryboard.loginVC()
//                if let topview = UIWindow.topViewController() {
//                    topview.present(loginVC, animated: true, completion: nil)
//                }
            })
        }
    }
    
    
  

}


extension NetworkManager {
    
    func sendPutRequest(urlPath: String, params:[String:Any], completion: @escaping (DataResponse<Any>) -> Void) {
        
        let url = AppURL.Domain + urlPath
        Alamofire.request(url, method: .put,
                          parameters: params,
                          encoding:JSONEncoding.default,
                          headers: self.buildRequestHeader())
            .responseJSON {response in
                self.handleRespone(response, completion)
        }
    }
    
    func sendRequest(urlPath:String,params:[String:Any]? = nil , completion: @escaping (DataResponse<Any>) -> Void) {
        
        let url = AppURL.Domain + urlPath
        var method:HTTPMethod = .post
        if params == nil {
            method = .get
        }
        Alamofire.request(url, method: method,
                          parameters: params,
                          encoding:JSONEncoding.default,
                          headers: self.buildRequestHeader())
            .responseJSON {response in
                self.handleRespone(response, completion)
        }
    }
    
    
   fileprivate func handleRespone(_ respone:DataResponse<Any>,
                                   _ completionBlock: @escaping (DataResponse<Any>) -> Void) {
        if respone.response?.statusCode == 403 {
            self.handleTokenExpỉed()
        }
        completionBlock(respone)
    }
}

extension DataResponse {
    
    var message:String? {
        
        if let result = self.result.value as? [String:Any] {
            return result["message"] as? String
        }
        return nil
    }
    
    var statusCode:Int {
        
        if let result = self.result.value as? [String:Any] {
            return result["status"] as? Int ?? 0
        }
        return 0
    }
    
    var error:Bool {
        
        if let data = self.result.value as? [String:Any] {
            return data["error"] as? Bool ?? false
        }
        return false
    }
    
    var mydata:[String:Any]? {
        
        if let result = self.result.value as? [String:Any] {
            return result["data"] as? [String:Any]
        }
        return nil
    }
    var array:[[String:Any]]? {
        if let result = self.result.value as? [String:Any] {
            return result["data"] as? [[String:Any]]
        }
        return nil
    }
}


