//
//  NotiModel.swift
//  TTS
//
//  Created by mac mini on 3/29/19.
//  Copyright © 2019 mac mini. All rights reserved.
//

import Foundation
class NotiModel: Codable {
    let id: Int?
    let notiID: Int?
    let title, body: String?
    let userID, wasRead: Int?
    let createdAt: String?
    let maOrder: String?
    let collapseKey: String?
    enum CodingKeys: String, CodingKey {
        case id, title, body
        case userID = "userId"
        case wasRead
        case createdAt
        case collapseKey = "collapse_key"
        case maOrder = "MaOrder"
        case notiID = "NotiID"

    }
    
    init(id: Int, title: String, body: String, userID: Int, wasRead: Int, createdAt: String, collapseKey: String, maOrder: String, notiID: Int) {
        self.id = id
        self.title = title
        self.body = body
        self.userID = userID
        self.wasRead = wasRead
        self.createdAt = createdAt
        self.collapseKey = collapseKey
        self.maOrder = maOrder
        self.notiID = notiID
    }
}
