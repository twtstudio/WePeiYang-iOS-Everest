//
//  PracticeNetwork.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/8/18.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

class PTExerciseNetwork {
    static func postWritingQues(courseId: String, quesType: String, index: String, isWrite: String, errorOption: String, success: @escaping (String) -> (), failure: @escaping (Error) -> ()) {
        let dic = ["course_id": courseId,
                   "ques_type": quesType,
                   "index": index,
                   "is_write": isWrite,
                   "error_option": errorOption]
        SolaSessionManager.solaSession(type: .post, baseURL: PracticeAPI.root, url: "/remember/current_course/write", parameters: dic, success: { (response) in
            let message = response["message"] as? String ?? ""
            success(message)
        }, failure: { (err) in
            failure(err)
        })
    }
    
    static func recordQuesIndex(courseId: Int, quesId: Int, quesType: Int, index: Int, success: @escaping (Int, String) -> (), failure: @escaping (Error) -> ()) {
        let dic = ["course_id": String(courseId),
                   "ques_type": String(quesType),
                   "ques_id": String(quesId),
                   "index": String(index)]
        SolaSessionManager.solaSession(type: .post, baseURL: PracticeAPI.root, url:  "/remember/mark", parameters: dic, success: { response in
            log(response)
        }) { err in
            log(err)
        }
    }

    func postRequest(urlString : String, params : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        Alamofire.request(urlString, method: HTTPMethod.post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                    log(value)
                }
            case .failure(let error):
                failture(error)
                log("error:\(error)")
            }
        }
    }

    static func getQues(courseId: Int, quesType: Int, id: Int, success: @escaping(PTQuestion)->(), failure: (Error)->()) {
        SolaSessionManager.solaSession(baseURL: "https://exam.twtstudio.com", url: "/api/remember/getQuesById/\(courseId)/\(quesType)/\(id)", success: { (dic) in
            let ques = dic["data"] as? [String: Any]
            if let quesDetail = ques {
                var question = PTQuestion()
                let id = quesDetail["ques_id"] as? Int
                let course_id = Int((quesDetail["course_id"] as! NSString).floatValue)
                let type = Int((quesDetail["ques_type"] as! NSString).floatValue)
                let content = quesDetail["content"] as? String ?? ""
                let option = quesDetail["option"] as? [String]
                let answer = quesDetail["answer"] as? String ?? ""
                let is_collected = quesDetail["is_collected"] as? Int
                let is_mistake = quesDetail["is_mistake"] as? Int
                let questionDetail = PTQuestionDetails(id: id, classId: nil, courseId: course_id, type: type, content: content, option: option, correctAnswer: answer, isCollected: is_collected, isMistake: is_mistake)
                question.quesDetail = questionDetail
                
                PTExerciseCollectionViewController.questions.append(question)
                success(question)
            }

        }) { (err) in
            log(err)
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
            log(err)
        }
    }

    static func deleteCollection(data: Dictionary<String, Any>, failure: @escaping (Error) -> (), success: @escaping (String) -> ()) {
        var message = ""
        SolaSessionManager.upload(dictionay: data, baseURL: "https://exam.twtstudio.com", url: "/api/collect/deleteCollection", method: .post, progressBlock: nil, failure: { (err) in
            log(err)
        }, success: { (dic) in
            message = dic["message"] as? String ?? ""
            print(message)
        })
        success(message)
    }

}

