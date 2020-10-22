//
//  AuditPersonalCourseModel.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/11/26.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct AuditPersonalCourseModel: Codable {
    let errorCode: Int
    let message: String
    let data: [AuditPersonalCourseList]
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct AuditPersonalCourseList: Codable {
    let courseID: Int
    let courseName, college: String
    let semester, year: Int
    let infos: [AuditDetailCourseItem]
    
    enum CodingKeys: String, CodingKey {
        case courseID = "course_id"
        case courseName = "course_name"
        case college, semester, year, infos
    }
}

// MARK: Convenience initializers and mutators

extension AuditPersonalCourseModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AuditPersonalCourseModel.self, from: data)
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

extension AuditPersonalCourseList {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AuditPersonalCourseList.self, from: data)
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
