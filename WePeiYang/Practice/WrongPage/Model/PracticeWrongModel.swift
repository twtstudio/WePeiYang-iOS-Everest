//
//  PracticeWrongModel.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/8/25.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

struct PracticeWrongHelper {
    static func getWrong(success: @escaping (PracticeWrongModel)->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(baseURL: PracticeAPI.root, url: PracticeAPI.special + "/getQues/1", success: { dic in
            // 删除 id 为 null 的题目 (好了后台又改回来了)
            var newDic = dic
            var ques = dic["ques"] as! [[String:Any]]
            var i = 0
            for que in ques {
                if que["id"] is NSNull {
                    ques.remove(at: i)
                } else { i += 1 }
            }
            let lessNumber = (newDic["ques"] as! [[String:Any]]).count - ques.count
            if lessNumber != 0 { SwiftMessages.showInfoMessage(body: "您错题本中的 \(lessNumber) 道错题已从题库中移除") }
            newDic["ques"] = ques
            
            if let data = try? JSONSerialization.data(withJSONObject: newDic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let practiceWrong = try? PracticeWrongModel(data: data) {
                success(practiceWrong)
            }
        }) { error in
            failure(error)
            print("ERROR -- PracticeWrongHelper.getWrong")
        }
    }
    
    static func deleteWrong(quesType: String, quesID: String) {
        SolaSessionManager.solaSession(type: .post, baseURL: PracticeAPI.root, url: PracticeAPI.special + "/deleteQues/1", parameters: ["ques_type": quesType, "ques_id": quesID], success: { dic in
        }) { _ in
            print("ERROR -- PracticeWrongHelper.deleteWrong")
        }
    }
}

struct PracticeWrongModel: Codable {
    let status: Int
    let tid: String
    var ques: [Que] // 基于数据和页面改为变量
}

struct Que: Codable {
    let id: Int
    let classID, courseID, type, content: String
    let option: [String]
    let answer: String
    let isCollected, isMistake: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case classID = "class_id"
        case courseID = "course_id"
        case type, content, option, answer
        case isCollected = "is_collected"
        case isMistake = "is_mistake"
    }
}

extension PracticeWrongModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PracticeWrongModel.self, from: data)
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
        tid: String? = nil,
        ques: [Que]? = nil
        ) -> PracticeWrongModel {
        return PracticeWrongModel(
            status: status ?? self.status,
            tid: tid ?? self.tid,
            ques: ques ?? self.ques
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Que {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Que.self, from: data)
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
        classID: String? = nil,
        courseID: String? = nil,
        type: String? = nil,
        content: String? = nil,
        option: [String]? = nil,
        answer: String? = nil,
        isCollected: Int? = nil,
        isMistake: Int? = nil
        ) -> Que {
        return Que(
            id: id ?? self.id,
            classID: classID ?? self.classID,
            courseID: courseID ?? self.courseID,
            type: type ?? self.type,
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
