//
//  PopularListModel.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/11/20.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct PopularListModel: Codable {
    let errorCode: Int
    let message: String
    let data: [PopularClassModel]
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct PopularClassModel: Codable {
    let rank, courseID, count: Int
    let updatedAt: String //Date
    let course: PopularDetailClassModel
    
    enum CodingKeys: String, CodingKey {
        case rank
        case courseID = "course_id"
        case count
        case updatedAt = "updated_at"
        case course
    }
}

struct PopularDetailClassModel: Codable {
    let id, collegeID: Int
    let name: String
    let year, semester: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case collegeID = "college_id"
        case name, year, semester
    }
}

// MARK: Convenience initializers and mutators

extension PopularListModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PopularListModel.self, from: data)
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
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension PopularClassModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PopularClassModel.self, from: data)
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
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension PopularDetailClassModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PopularDetailClassModel.self, from: data)
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
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
