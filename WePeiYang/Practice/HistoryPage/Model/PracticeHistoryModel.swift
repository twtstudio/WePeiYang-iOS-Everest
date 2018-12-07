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
    
    static func getResultInfo(of time: String, success: @escaping (PTQuizResult) -> ()) {
        SolaSessionManager.solaSession(baseURL: PracticeAPI.root, url: "/student/exercise_result", parameters: ["time": time], success: { (dict) in
            let data = dict["data"] as? [String: Any] ?? [:]
            let score = data["score"] as? Int ?? 2
            let timestamp = data["timestamp"] as? Int ?? 2
            let correctNum = data["correct_num"] as? Int ?? 0
            let errorNum = data["error_num"] as? Int ?? 0
            let notDoneNum = data["not_done_num"] as? Int ?? 0
            guard let results = data["result"] as? [[String: Any]] else { return }
            var pQuizResultData: [PTQuizResultData] = []
            for result in results {
                let quesId = result["ques_id"] as? String ?? ""
                let quesType = result["ques_type"] as? String ?? ""
                let content = result["ques_content"] as? String ?? ""
                let option = result["ques_option"] as? [String] ?? []
                let isDone = result["is_done"] as? Int ?? 2
                let isTrue = result["is_true"] as? Int ?? 2
                let answer = result["answer"] as? String ?? ""
                let trueAns = result["true_answer"] as? String ?? ""
                let isCollect = result["is_collected"] as? Int ?? 2
                
                let qdata = PTQuizResultData(quesID: quesId, quesType: quesType, content: content, option: option, answer: trueAns, isCollected: isCollect, errorOption: answer, isDone: isDone, isTrue: isTrue)
                pQuizResultData.append(qdata)
            }
            let pQuizResult = PTQuizResult.init(score: score, timestamp: timestamp, correctNum: correctNum, errNum: errorNum, notDoneNum: notDoneNum, practiceTime: "", results: pQuizResultData)
            success(pQuizResult)
        }) { (err) in
            log(err)
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
    let score, time: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case courseID = "course_id"
        case classID = "class_id"
        case courseName = "course_name"
        case quesType = "ques_type"
        case quesCount = "ques_count"
        case doneCount = "done_count"
        case doneIndex = "done_index"
        case timestamp, score, time
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
        score: String?? = nil,
        time: String?? = nil
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
            score: score ?? self.score,
            time: time ?? self.time
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
