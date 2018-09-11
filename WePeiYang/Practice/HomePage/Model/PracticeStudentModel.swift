//
//  PracticeStudentModel.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/8/25.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

struct PracticeAPI { // 参考 Bike 模块, 考虑单独抽出为一个文件
    
    static let root = "https://exam.twtstudio.com/api"
    
    static let student = "/student"
    
    static let remember = "/remember"
    
    static let special = "/special"
    
}

struct PracticeStudentHelper {
    static func getStudent(success: @escaping (PracticeStudentModel)->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(baseURL: PracticeAPI.root, url: PracticeAPI.student, success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let practiceStudent = try? PracticeStudentModel(data: data) {
                success(practiceStudent)
            } else { print("WARNING -- PracticeStudentHelper.getStudent") }
        }) { error in
            failure(error)
            print("ERROR -- PracticeStudentHelper.getStudent")
        }
    }
}

struct PracticeStudentModel: Codable {
    let errorCode: Int
    let message: String
    let data: PracticeStudentData
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct PracticeStudentData: Codable {
    let id: Int
    let twtName, userNumber, avatarURL, titleName: String
    let doneCount, errorCount: String
    let courseCount: Int
    let collectCount, currentCourseID, currentCourseName, currentCourseDoneCount: String
    let currentQuesType, currentCourseQuesCount, currentCourseIndex, latestCourseName: String
    let latestCourseTimestamp: Int
    let qSelect: [QuickSelect]
    
    enum CodingKeys: String, CodingKey {
        case id
        case twtName = "twt_name"
        case userNumber = "user_number"
        case avatarURL = "avatar_url"
        case titleName = "title_name"
        case doneCount = "done_count"
        case errorCount = "error_count"
        case courseCount = "course_count"
        case collectCount = "collect_count"
        case currentCourseID = "current_course_id"
        case currentCourseName = "current_course_name"
        case currentCourseDoneCount = "current_course_done_count"
        case currentQuesType = "current_ques_type"
        case currentCourseQuesCount = "current_course_ques_count"
        case currentCourseIndex = "current_course_index"
        case latestCourseName = "latest_course_name"
        case latestCourseTimestamp = "latest_course_timestamp"
        case qSelect
    }
}

struct QuickSelect: Codable {
    let id: Int
    let courseName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseName = "course_name"
    }
}

extension PracticeStudentModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PracticeStudentModel.self, from: data)
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
    
    func with(
        errorCode: Int? = nil,
        message: String? = nil,
        data: PracticeStudentData? = nil
        ) -> PracticeStudentModel {
        return PracticeStudentModel(
            errorCode: errorCode ?? self.errorCode,
            message: message ?? self.message,
            data: data ?? self.data
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension PracticeStudentData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PracticeStudentData.self, from: data)
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
    
    func with(
        id: Int? = nil,
        twtName: String? = nil,
        userNumber: String? = nil,
        avatarURL: String? = nil,
        titleName: String? = nil,
        doneCount: String? = nil,
        errorCount: String? = nil,
        courseCount: Int? = nil,
        collectCount: String? = nil,
        currentCourseID: String? = nil,
        currentCourseName: String? = nil,
        currentCourseDoneCount: String? = nil,
        currentQuesType: String? = nil,
        currentCourseQuesCount: String? = nil,
        currentCourseIndex: String? = nil,
        latestCourseName: String? = nil,
        latestCourseTimestamp: Int? = nil,
        qSelect: [QuickSelect]? = nil
        ) -> PracticeStudentData {
        return PracticeStudentData(
            id: id ?? self.id,
            twtName: twtName ?? self.twtName,
            userNumber: userNumber ?? self.userNumber,
            avatarURL: avatarURL ?? self.avatarURL,
            titleName: titleName ?? self.titleName,
            doneCount: doneCount ?? self.doneCount,
            errorCount: errorCount ?? self.errorCount,
            courseCount: courseCount ?? self.courseCount,
            collectCount: collectCount ?? self.collectCount,
            currentCourseID: currentCourseID ?? self.currentCourseID,
            currentCourseName: currentCourseName ?? self.currentCourseName,
            currentCourseDoneCount: currentCourseDoneCount ?? self.currentCourseDoneCount,
            currentQuesType: currentQuesType ?? self.currentQuesType,
            currentCourseQuesCount: currentCourseQuesCount ?? self.currentCourseQuesCount,
            currentCourseIndex: currentCourseIndex ?? self.currentCourseIndex,
            latestCourseName: latestCourseName ?? self.latestCourseName,
            latestCourseTimestamp: latestCourseTimestamp ?? self.latestCourseTimestamp,
            qSelect: qSelect ?? self.qSelect
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension QuickSelect {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(QuickSelect.self, from: data)
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
    
    func with(
        id: Int? = nil,
        courseName: String? = nil
        ) -> QuickSelect {
        return QuickSelect(
            id: id ?? self.id,
            courseName: courseName ?? self.courseName
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
