//
//  AuditSearchModel.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/11/21.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct AuditSearchModel: Codable {
    let errorCode: Int
    let message: String
    let data: [AuditSearchData]
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct AuditSearchData: Codable {
    let id, collegeID: Int
    let name: String
    let year, semester: Int
    //let college: College
    let info: [AuditDetailCourseItem]
    
    enum CodingKeys: String, CodingKey {
        case id
        case collegeID = "college_id"
        case name, year, semester, info
        //case name, year, semester, college, info
    }
}

//struct College: Codable {
//    let id: Int
//    let name: Name
//}

// MARK: Convenience initializers and mutators

extension AuditSearchModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AuditSearchModel.self, from: data)
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

extension AuditSearchData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AuditSearchData.self, from: data)
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
