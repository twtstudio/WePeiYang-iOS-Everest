//
//  CourseAppraiseManager.swift
//  WePeiYang
//
//  Created by JinHongxu on 2017/1/14.
//  Copyright © 2017年 Qin Yubo. All rights reserved.
//

class CourseAppraiseManager {
    
    var scoreArray = [5, 5, 5, 5, 5]
    var detailAppraiseEnabled = false
    var lesson_id: String?
    var union_id: String?
    var course_id: String?
    var term: String?
    var note = ""
    var GPASession: String?
    
    static let shared = CourseAppraiseManager()
    private init() {}
    
    func submit(successHandler: @escaping ()->()) {
        
        // let manager = AFHTTPSessionManager()
        let parameters = ["lesson_id": lesson_id!,
                          "union_id": union_id!,
                          "course_id": course_id!,
                          "term": term!,
                          "q1": "\(scoreArray[0])",
            "q2": "\(scoreArray[1])",
            "q3": "\(scoreArray[2])",
            "q4": "\(scoreArray[3])",
            "q5": "\(scoreArray[4])",
            "note": note]
        print(parameters)
        
        let url = "/gpa/evaluate?token=\(GPASession!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        SolaSessionManager.solaSession(type: .duo, url: url!, token: GPASession!, parameters: parameters, success: { dict in
            // MsgDisplay.showSuccessMsg("评论成功!")
            successHandler()
        }, failure: { error in
            // FIXME: display error
//            MsgDisplay.showErrorMsg("评论失败")
        })
    }
    
    func setInfo(lesson_id: String, union_id: String, course_id: String, term: String, GPASession: String) {
        scoreArray = [5, 5, 5, 5, 5]
        detailAppraiseEnabled = false
        self.note = ""
        self.lesson_id = lesson_id
        self.union_id = union_id
        self.course_id = course_id
        self.term = term
        self.GPASession = GPASession
    }
}
