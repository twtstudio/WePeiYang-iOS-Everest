//
//  FoodMainPageModel.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/5/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation


struct FoodMainPageModel: Codable {
    let errorCode: Int
    let message: String
    let data: FoodMainPageData
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct FoodMainPageData: Codable {
    let top10Food: [Top10Food]
    let canteenList: [CanteenList]
    let goodComment: [GoodComment]
}

struct CanteenList: Codable {
    let canteenID: Int
    let canteenName: String
    let canteenPhone: Int
    let canteenAddress, canteenTime: String
    let canteenFloor: Int
    let createdAt, updatedAt: String
    let deletedAt: JSONNull?
    let canteenPictureAddress: String
    
    enum CodingKeys: String, CodingKey {
        case canteenID = "canteen_id"
        case canteenName = "canteen_name"
        case canteenPhone = "canteen_phone"
        case canteenAddress = "canteen_address"
        case canteenTime = "canteen_time"
        case canteenFloor = "canteen_floor"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case canteenPictureAddress = "canteen_picture_address"
    }
}

struct GoodComment: Codable {
    let commentID: Int
    let foodName: JSONNull?
    let foodID, commenterID: Int
    let commenterName, foodTime: String
    let foodScore: Int
    let commentContent: String
    let commentPraiseNumber, commentIsAnonymous: Int
    let pictureAddress1, pictureAddress2, pictureAddress3, pictureAddress4: String
    let createdAt: String
    let deletedAt: JSONNull?
    let updatedAt: String
    let isCurrentUserPraised: Bool
    
    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case foodName = "food_name"
        case foodID = "food_id"
        case commenterID = "commenter_id"
        case commenterName = "commenter_name"
        case foodTime = "food_time"
        case foodScore = "food_score"
        case commentContent = "comment_content"
        case commentPraiseNumber = "comment_praise_number"
        case commentIsAnonymous = "comment_is_anonymous"
        case pictureAddress1 = "picture_address1"
        case pictureAddress2 = "picture_address2"
        case pictureAddress3 = "picture_address3"
        case pictureAddress4 = "picture_address4"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case updatedAt = "updated_at"
        case isCurrentUserPraised
    }
}

struct Top10Food: Codable {
    let foodID: Int
    let foodStatement, foodName, foodTime: String
    let foodPrice: Int
    let foodPictureAddress: String
    let canteenID: Int
    let canteenName, foodFloor: String
    let foodWindow, foodCommentNumber, foodPraiseNumber, foodTotalScore: Int
    let foodScore, foodCollectNumber: Int
    let createdAt: String
    let deletedAt: JSONNull?
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case foodID = "food_id"
        case foodStatement = "food_statement"
        case foodName = "food_name"
        case foodTime = "food_time"
        case foodPrice = "food_price"
        case foodPictureAddress = "food_picture_address"
        case canteenID = "canteen_id"
        case canteenName = "canteen_name"
        case foodFloor = "food_floor"
        case foodWindow = "food_window"
        case foodCommentNumber = "food_comment_number"
        case foodPraiseNumber = "food_praise_number"
        case foodTotalScore = "food_total_score"
        case foodScore = "food_score"
        case foodCollectNumber = "food_collect_number"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case updatedAt = "updated_at"
    }
}


// MARK: Convenience initializers

extension FoodMainPageModel {
    init(data: Data) throws {
        self = try JSONDecoder().decode(FoodMainPageModel.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension FoodMainPageData {
    init(data: Data) throws {
        self = try JSONDecoder().decode(FoodMainPageData.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension CanteenList {
    init(data: Data) throws {
        self = try JSONDecoder().decode(CanteenList.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension GoodComment {
    init(data: Data) throws {
        self = try JSONDecoder().decode(GoodComment.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Top10Food {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Top10Food.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

