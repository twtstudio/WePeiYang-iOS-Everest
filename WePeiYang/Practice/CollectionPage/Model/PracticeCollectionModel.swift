//
//  PracticeCollectionModel.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/9/1.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

struct PracticeCollectionHelper {
    static func getCollection(success: @escaping (PracticeCollectionModel)->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(baseURL: PracticeAPI.root, url: PracticeAPI.special + "/getQues/0", success: { dic in
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
            if lessNumber != 0 { SwiftMessages.showInfoMessage(body: "您收藏中的 \(lessNumber) 道题已从题库中移除") }
            newDic["ques"] = ques
            
            if let data = try? JSONSerialization.data(withJSONObject: newDic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let practiceCollection = try? PracticeCollectionModel(data: data) {
                success(practiceCollection)
            }
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

struct PracticeCollectionModel: Codable {
    let status: Int
    let tid: String
    var ques: [Que] // 基于数据和页面改为变量
}

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
        status: Int? = nil,
        tid: String? = nil,
        ques: [Que]? = nil
        ) -> PracticeCollectionModel {
        return PracticeCollectionModel(
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
