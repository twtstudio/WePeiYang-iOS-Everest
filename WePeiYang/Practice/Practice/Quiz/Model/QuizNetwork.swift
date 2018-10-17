//
//  File.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/7.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

class QuizNetWork {
    static func postQuizResult(dics: [String: Any], courseId: Int, time: Int, success: @escaping (Dictionary<String, Any>)->()) {
        SolaSessionManager.upload(dictionay: dics, url: "/api/exercise/getScore/\(courseId)/\(time)", success: success)
    }
    
    static func getQuizQuesArray(courseId: Int, success: @escaping ([QuizQuestion], Int) -> (), failure: (Error) -> ()) {
        SolaSessionManager.solaSession(type: .get, baseURL:  "https://exam.twtstudio.com", url: "/api/exercise/getQues/\(courseId)", success: { (data) in
            var questionArray: [QuizQuestion] = []
//            let errorCode = data["error_code"] as? Int ?? 1
//            let message = data["message"] as? String ?? ""
            var time: Int = 0
//            var timestamp: String = ""
            if let dic = data["data"] as? [String: Any] {
                time = dic["time"] as? Int ?? 0
//                timestamp = dic["timestamp"] as? String ?? ""
                let questionDic = dic["question"] as? [[String: Any]] ?? []
                for ques in questionDic {
                    let id = ques["ques_id"] as? Int
                    let courseId = Int((ques["course_id"] as! NSString).floatValue)
                    let type = ques["ques_type"] as! Int
                    let content = ques["content"] as? String ?? ""
                    let option = ques["option"] as? [String]
                    let isCollceted = ques["is_collected"] as? Int ?? 3
                    let question = QuizQuestion(id: id, courseId: courseId, quesType: type, content: content, options: option, isCollected: isCollceted)
                    questionArray.append(question)
                }
//                success(questionArray)
            }
            success(questionArray, time)
        }) { (err) in
            debugLog(err)
        }
    }
}
