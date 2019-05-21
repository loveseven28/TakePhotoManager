//
//  SwiftDecoder.swift
//  VoucherMaker
//
//  Created by macOS on 12/21/18.
//  Copyright © 2018 mac mini. All rights reserved.
//

import Foundation

class SwiftDecoder {
    
    internal func decodableToObjects<T: Codable>(response: Any, keyPath: String? = "") -> (T?, Error?) {
        if let nestedJSON = keyPath!.isEmpty ? response as AnyObject : (response as AnyObject).value(forKeyPath: keyPath!), let _ = nestedJSON as? [[String: Any]] {
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                let data = try JSONSerialization.data(withJSONObject: nestedJSON)
                let object = try decoder.decode(T.self, from: data)
                return (object, nil)
                
            } catch {
                return (nil, error)
            }
        } else {
            return (nil, nil)
        }
    }
    
    internal func decodableToObject<T: Codable>(response: Any, keyPath: String? = "") -> (T?, Error?) {
        
        if let nestedJson = keyPath!.isEmpty ? response as AnyObject : (response as AnyObject).value(forKeyPath: keyPath!), let _ = nestedJson as? [String: Any] {
            do {
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                let data = try JSONSerialization.data(withJSONObject: nestedJson)
                let object = try decoder.decode(T.self, from: data)
                return (object, nil)
            }catch {
                print("PARSE DATA FAILED: \(error)")
                return (nil, error)
            }
        }else {
            return (nil, nil)
        }
    }
    
    func encodeObject<T: Codable>(_ encoder: JSONEncoder, with object: T) -> (Error?, Params) {
        do {
            let data = try encoder.encode(object)
            let params = try JSONSerialization.jsonObject(with: data)
            
            return (nil, params as? [String: Any])
        } catch {
            return (error, nil)
        }
    }
    
}

enum ResultStatusCode<NetworkResponseError> {
    case success
    case failure(NetworkResponseError)
}

enum NetworkResponseError: Error {
    case authenticationError // = "you need to be authenticated first"
    case badRequest // = "Bad request"
    case outdated // = "the url you requested is outdated"
    case failed // = "request failed"
    case noData // = "response returned with no data to decode"
    case unableToDecode // = "we cound not decode the response"
    case timeout // = "we cound not decode the response"
    case canceled //
}

extension NetworkResponseError: LocalizedError {
    var localizedDescription: String {
        get {
            switch self {
            case .authenticationError:
                return "you need to be authenticated first"
            case .badRequest:
                return "Bad request"
            case .outdated:
                return "the url you requested is outdated"
            case .failed:
                return "request failed"
            case .noData:
                return "response returned with no data to decode"
            case .unableToDecode:
                return "we cound not decode the response"
            case .timeout:
                return "request time out"
            case .canceled:
                return "request bi huy"
            }
        }
    }
}

extension KeyedDecodingContainer {
    func decodeWrapper<T>(key: K, defaultValue: T) throws -> T
        where T : Decodable {
            return try decodeIfPresent(T.self, forKey: key) ?? defaultValue
    }
}
