//
//  PracticeCollectionModel.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/9/1.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

// MARK: Network
struct PracticeCollectionHelper {
    static func getCollection(success: @escaping (PracticeCollectionModel)->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(baseURL: PracticeAPI.root, url: PracticeAPI.special + "/getQues/0", success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let practiceCollection = try? PracticeCollectionModel(data: data) {
                success(practiceCollection)
            } else { print("WARNING -- PracticeCollectionHelper.getCollection") }
        }) { error in
            failure(error)
            print("ERROR -- PracticeCollectionHelper.getCollection")
        }
    }
    
    static func addCollection(quesType: String, quesID: String) {
        SolaSessionManager.solaSession(type: .post, baseURL: PracticeAPI.root, url: PracticeAPI.special + "/addQues/0", parameters: ["ques_type": quesType, "ques_id": quesID], success: { dic in
        }) { _ in
            print("ERROR -- PracticeCollectionHelper.addCollection")
        }
    }
    
    static func deleteCollection(quesType: String, quesID: String) {
        SolaSessionManager.solaSession(type: .post, baseURL: PracticeAPI.root, url: PracticeAPI.special + "/deleteQues/0", parameters: ["ques_type": quesType, "ques_id": quesID], success: { dic in
        }) { _ in
            print("ERROR -- PracticeCollectionHelper.deleteCollection")
        }
    }
}

// MARK: - Model
struct PracticeCollectionModel: Codable {
    let errorCode: Int
    let message: String
    var data: [PracticeCollectionData] // 基于数据和页面改为变量
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct PracticeCollectionData: Codable {
    let quesID: Int
    let classID, courseID, quesType, content: String
    let option: [String]
    let answer: String
    let isCollected, isMistake: Int
    
    enum CodingKeys: String, CodingKey {
        case quesID = "ques_id"
        case classID = "class_id"
        case courseID = "course_id"
        case quesType = "ques_type"
        case content, option, answer
        case isCollected = "is_collected"
        case isMistake = "is_mistake"
    }
}

// MARK: - Initialization
extension PracticeCollectionModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PracticeCollectionModel.self, from: data)
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
        data: [PracticeCollectionData]? = nil
        ) -> PracticeCollectionModel {
        return PracticeCollectionModel(
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

extension PracticeCollectionData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PracticeCollectionData.self, from: data)
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
        quesID: Int? = nil,
        classID: String? = nil,
        courseID: String? = nil,
        quesType: String? = nil,
        content: String? = nil,
        option: [String]? = nil,
        answer: String? = nil,
        isCollected: Int? = nil,
        isMistake: Int? = nil
        ) -> PracticeCollectionData {
        return PracticeCollectionData(
            quesID: quesID ?? self.quesID,
            classID: classID ?? self.classID,
            courseID: courseID ?? self.courseID,
            quesType: quesType ?? self.quesType,
            content: content ?? self.content,
            option: option ?? self.option,
            answer: answer ?? self.answer,
            isCollected: isCollected ?? self.isCollected,
            isMistake: isMistake ?? self.isMistake
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
