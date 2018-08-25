//
//  PracticeStudentModel.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/8/25.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

struct PracticeAPI {
    
    static let root = "https://exam.twtstudio.com/api"
    
    static let student = "/student"
    
    static let remember = "/remember"
    
    static let special = "/special"
    
}

struct PracticeStudentHelper {
    static func getStudent(success: @escaping (PracticeStudentModel)->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(baseURL: PracticeAPI.root, url: PracticeAPI.student, token: TwTUser.shared.token, success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let practiceStudent = try? PracticeStudentModel(data: data) {
                success(practiceStudent)
            }
        }) { error in
            failure(error)
        }
    }
}

struct PracticeStudentModel: Codable {
    let status: Int
    let message: String
    let data: PracticeStudentData
}

struct PracticeStudentData: Codable {
    let id: Int
    let twtName, userNumber, type, avatarURL: String
    let title: Title
    let quesMessage: QuesMessage
    let history: HistoryTopModel
    
    enum CodingKeys: String, CodingKey {
        case id
        case twtName = "twt_name"
        case userNumber = "user_number"
        case type
        case avatarURL = "avatar_url"
        case title
        case quesMessage = "ques_message"
        case history
    }
}

struct HistoryTopModel: Codable {
    let status: Int
    let history: [HistoryModel]
}

struct HistoryModel: Codable {
    let type: Int
    let date, courseID: String
    let quesType: String?
    let courseName: String
    let score: Int?
    
    enum CodingKeys: String, CodingKey {
        case type, date
        case courseID = "course_id"
        case quesType = "ques_type"
        case courseName = "course_name"
        case score
    }
}

struct QuesMessage: Codable {
    let doneNumber, errorNumber: String
    let rememberCourseNumber: Int
    let rememberNumber, collectNumber: String
    
    enum CodingKeys: String, CodingKey {
        case doneNumber = "done_number"
        case errorNumber = "error_number"
        case rememberCourseNumber = "remember_course_number"
        case rememberNumber = "remember_number"
        case collectNumber = "collect_number"
    }
}

struct Title: Codable {
    let titleName: String
    
    enum CodingKeys: String, CodingKey {
        case titleName = "title_name"
    }
}

extension PracticeStudentModel {
    init(data: Data) throws {
        self = try JSONDecoder().decode(PracticeStudentModel.self, from: data)
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
        status: Int? = nil,
        message: String? = nil,
        data: PracticeStudentData? = nil
        ) -> PracticeStudentModel {
        return PracticeStudentModel(
            status: status ?? self.status,
            message: message ?? self.message,
            data: data ?? self.data
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension PracticeStudentData {
    init(data: Data) throws {
        self = try JSONDecoder().decode(PracticeStudentData.self, from: data)
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
        type: String? = nil,
        avatarURL: String? = nil,
        title: Title? = nil,
        quesMessage: QuesMessage? = nil,
        history: HistoryTopModel? = nil
        ) -> PracticeStudentData {
        return PracticeStudentData(
            id: id ?? self.id,
            twtName: twtName ?? self.twtName,
            userNumber: userNumber ?? self.userNumber,
            type: type ?? self.type,
            avatarURL: avatarURL ?? self.avatarURL,
            title: title ?? self.title,
            quesMessage: quesMessage ?? self.quesMessage,
            history: history ?? self.history
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension HistoryTopModel {
    init(data: Data) throws {
        self = try JSONDecoder().decode(HistoryTopModel.self, from: data)
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
        status: Int? = nil,
        history: [HistoryModel]? = nil
        ) -> HistoryTopModel {
        return HistoryTopModel(
            status: status ?? self.status,
            history: history ?? self.history
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension HistoryModel {
    init(data: Data) throws {
        self = try JSONDecoder().decode(HistoryModel.self, from: data)
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
        type: Int? = nil,
        date: String? = nil,
        courseID: String? = nil,
        quesType: String?? = nil,
        courseName: String? = nil,
        score: Int?? = nil
        ) -> HistoryModel {
        return HistoryModel(
            type: type ?? self.type,
            date: date ?? self.date,
            courseID: courseID ?? self.courseID,
            quesType: quesType ?? self.quesType,
            courseName: courseName ?? self.courseName,
            score: score ?? self.score
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension QuesMessage {
    init(data: Data) throws {
        self = try JSONDecoder().decode(QuesMessage.self, from: data)
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
        doneNumber: String? = nil,
        errorNumber: String? = nil,
        rememberCourseNumber: Int? = nil,
        rememberNumber: String? = nil,
        collectNumber: String? = nil
        ) -> QuesMessage {
        return QuesMessage(
            doneNumber: doneNumber ?? self.doneNumber,
            errorNumber: errorNumber ?? self.errorNumber,
            rememberCourseNumber: rememberCourseNumber ?? self.rememberCourseNumber,
            rememberNumber: rememberNumber ?? self.rememberNumber,
            collectNumber: collectNumber ?? self.collectNumber
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Title {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Title.self, from: data)
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
        titleName: String? = nil
        ) -> Title {
        return Title(
            titleName: titleName ?? self.titleName
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
