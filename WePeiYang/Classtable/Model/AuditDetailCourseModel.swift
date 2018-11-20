//
//  AuditDetailCourseModel.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/11/21.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct AuditDetailCourseModel: Codable {
    let errorCode: Int
    let message: String
    let data: AuditDetailCourseList
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct AuditDetailCourseList: Codable {
    let id, collegeID: Int
    let name: String
    let year, semester: Int
    let college: String
    let info: [AuditDetailCourseItem]
    
    enum CodingKeys: String, CodingKey {
        case id
        case collegeID = "college_id"
        case name, year, semester, college, info
    }
}

struct AuditDetailCourseItem: Codable {
    let id, courseID: Int
    let courseName: String
    let courseIDInTju: Int? //JSONNull?
    let startWeek, endWeek, startTime, courseLength: Int
    let weekDay, weekType: Int
    let building, room, teacherType, teacher: String
    var courseCollege: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseID = "course_id"
        case courseName = "course_name"
        case courseIDInTju = "course_id_in_tju"
        case startWeek = "start_week"
        case endWeek = "end_week"
        case startTime = "start_time"
        case courseLength = "course_length"
        case weekDay = "week_day"
        case weekType = "week_type"
        case building, room
        case teacherType = "teacher_type"
        case teacher
        //case courseCollege
    }
}

// MARK: Convenience initializers and mutators

extension AuditDetailCourseModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AuditDetailCourseModel.self, from: data)
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

extension AuditDetailCourseList {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AuditDetailCourseList.self, from: data)
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

extension AuditDetailCourseItem {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AuditDetailCourseItem.self, from: data)
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
