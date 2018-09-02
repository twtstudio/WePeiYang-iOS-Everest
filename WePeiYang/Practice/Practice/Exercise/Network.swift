//
//  Network.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/26.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

class PracticeNetwork {
    static func getQues(courseId: Int, quesType: Int, id: Int, success: @escaping (Question) -> (), failure: (Error) -> ()) {
        SolaSessionManager.solaSession(url: "/api/remember/getQuesById/\(courseId)/\(quesType)/\(id)", success: { (dic) in
            var question = Question()
            if let status = dic["status"] as? Int, let ans = dic["answer"] as? String {
                question.status = status
                question.answer = ans
                
                if let quesData = dic["ques"] as? [[String : Any]] {
                    var questionDetail = QuestionDetails()
                    for ques in quesData {
                        questionDetail.id = ques["id"] as? Int ?? nil
                        questionDetail.courseId = ques["course_id"] as? Int ?? nil
                        questionDetail.type = ques["type"] as? Int ?? nil
                        questionDetail.content = ques["content"] as? String ?? ""
                        questionDetail.option = ques["option"] as? [String] ?? []
                    }
                    question.ques = questionDetail
                    
                    success(question)
                }
            }
        }) { (err) in
            print(err)
        }
    }
}
