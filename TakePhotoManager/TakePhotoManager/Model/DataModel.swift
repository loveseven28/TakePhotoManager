//
//  DataModel.swift
//  TTS
//
//  Created by mac mini on 3/18/19.
//  Copyright © 2019 mac mini. All rights reserved.
//

import Foundation


struct DataModel<T: Codable>: Codable {
    let status: Int?
    let data: T?
    let msg: String
}

struct DataModels<T: Codable>: Codable {
    let status: Int?
    let data: [T]?
    let msg: String
}

struct DataLoadMore<T: Codable>: Codable {
    let data: [T]?
    let last_page: Int
}
