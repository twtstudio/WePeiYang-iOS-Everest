//
//  PracticeNetwork.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/8/18.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

class ExerciseNetwork {
    
    static func getQues(courseId: Int, quesType: Int, id: Int, success: @escaping(Question)->(), failure: (Error)->()) {
        SolaSessionManager.solaSession(baseURL: "https://exam.twtstudio.com", url: "/api/remember/getQuesById/\(courseId)/\(quesType)/\(id)", success: { (dic) in
//            let status = dic["status"] as? Int ?? 3
            let ques = dic["data"] as? [String: Any]
            if let quesDetail = ques {
                var question = Question()

                let id = quesDetail["ques_id"] as? Int
//                let class_id = Int((quesDetail["class_id"] as! NSString).floatValue)
                let course_id = Int((quesDetail["course_id"] as! NSString).floatValue)
                let type = Int((quesDetail["ques_type"] as! NSString).floatValue)
                let content = quesDetail["content"] as? String ?? ""
                let option = quesDetail["option"] as? [String]
                let answer = quesDetail["answer"] as? String ?? ""
                let is_collected = quesDetail["is_collected"] as? Int
                let is_mistake = quesDetail["is_mistake"] as? Int
                let questionDetail = QuestionDetails(id: id, classId: nil, courseId: course_id, type: type, content: content, option: option, correctAnswer: answer, isCollected: is_collected, isMistake: is_mistake)
                question.quesDetail = questionDetail
//                question.status = status
                
                ExerciseCollectionViewController.questions.append(question)
                success(question)
            }

        }) { (err) in
            debugLog(err)
        }
    }
    
    static func getIdList(courseId: Int, quesType: Int, success: @escaping ([Int?]) -> (), failure: (Error) -> ()) {
        SolaSessionManager.solaSession(baseURL: "https://exam.twtstudio.com", url: "/api/remember/getAllId/\(courseId)/\(quesType)", success: { (dic) in
            var idArray: [Int] = []
            if let idList = dic["data"] as? [Int] {
                idArray = idList
            }
            success(idArray)
        }) { (err) in
            debugLog(err)
        }
    }

    
    static func postMistakeQues(courseId: Int, data: Dictionary<String, Any>, failure: @escaping (Error) ->(), success: @escaping (Dictionary<String, Any>) -> ()) {
        SolaSessionManager.upload(dictionay: data, url: "/api/remember/addMistakeQues/\(1)", method: .post, progressBlock: nil, failure: { (err) in
            print(err)
        }, success: success)
    }
    
    static func addCollection(data: Dictionary<String, Any>, failure: @escaping (Error) -> (), success: @escaping (Dictionary<String, Any>) -> ()) {
        SolaSessionManager.upload(dictionay: data, url: "/api/special/addQues/\(0)", method: .post, progressBlock: nil, failure: { (err) in
            print(err)
        }, success: success)
    }
    
    static func deleteCollection(data: Dictionary<String, Any>, failure: @escaping (Error) -> (), success: @escaping (Dictionary<String, Any>) -> ()) {
        SolaSessionManager.upload(dictionay: data, url: "/api/collect/deleteCollection", method: .post, progressBlock: nil, failure: { (err) in
            print(err)
        }, success: success)
    }

}

