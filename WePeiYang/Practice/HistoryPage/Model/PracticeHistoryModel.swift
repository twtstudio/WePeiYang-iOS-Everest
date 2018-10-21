//
//  PracticeHistoryModel.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/9/11.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

// MARK: Network
struct PracticeHistoryHelper {
    static func getHistory(success: @escaping (PracticeHistoryModel)->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(baseURL: PracticeAPI.root, url: PracticeAPI.student + "/history", success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let practiceHistory = try? PracticeHistoryModel(data: data) {
                success(practiceHistory)
            } else { debugPrint("WARNING -- PracticeHistoryHelper.getHistory") }
        }) { error in
            failure(error)
            debugPrint("ERROR -- PracticeHistoryHelper.getHistory")
        }
    }
}

// MARK: - Model
struct PracticeHistoryModel: Codable {
    let errorCode: Int
    let message: String
    let data: [PracticeHistoryData]
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct PracticeHistoryData: Codable {
    let type, courseID, classID, courseName: String
    let quesType, quesCount, doneCount: String?
    let doneIndex, timestamp: String
    let score: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case courseID = "course_id"
        case classID = "class_id"
        case courseName = "course_name"
        case quesType = "ques_type"
        case quesCount = "ques_count"
        case doneCount = "done_count"
        case doneIndex = "done_index"
        case timestamp, score
    }
}

// MARK: - Initialization
extension PracticeHistoryModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PracticeHistoryModel.self, from: data)
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
        data: [PracticeHistoryData]? = nil
        ) -> PracticeHistoryModel {
        return PracticeHistoryModel(
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

extension PracticeHistoryData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PracticeHistoryData.self, from: data)
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
        type: String? = nil,
        courseID: String? = nil,
        classID: String? = nil,
        courseName: String? = nil,
        quesType: String?? = nil,
        quesCount: String?? = nil,
        doneCount: String?? = nil,
        doneIndex: String? = nil,
        timestamp: String? = nil,
        score: String?? = nil
        ) -> PracticeHistoryData {
        return PracticeHistoryData(
            type: type ?? self.type,
            courseID: courseID ?? self.courseID,
            classID: classID ?? self.classID,
            courseName: courseName ?? self.courseName,
            quesType: quesType ?? self.quesType,
            quesCount: quesCount ?? self.quesCount,
            doneCount: doneCount ?? self.doneCount,
            doneIndex: doneIndex ?? self.doneIndex,
            timestamp: timestamp ?? self.timestamp,
            score: score ?? self.score
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
