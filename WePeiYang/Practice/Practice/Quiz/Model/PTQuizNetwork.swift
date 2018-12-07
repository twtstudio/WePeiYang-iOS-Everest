//
//  File.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/7.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

class PTQuizNetWork {
    static func postQuizResult(dics: [String: String], courseId: String, time: Int, token: String? = nil, success: @escaping (PTQuizResult)->()) {
        let timeStamp = String(Int64(Date().timeIntervalSince1970))
        var para = [String: String]()
        para["t"] = timeStamp
        var fooPara = para
        let keys = fooPara.keys.sorted()
        // encrypt with sha1
        var tmpSign = ""
        for key in keys {
            tmpSign += (key + fooPara[key]!)
        }
        
        let sign = (TwTKeychain.shared.appKey + tmpSign + TwTKeychain.shared.appSecret).sha1.uppercased()
        para["sign"] = sign
        para["app_key"] = TwTKeychain.shared.appKey
        
        var headers = HTTPHeaders()
        headers["User-Agent"] = DeviceStatus.userAgent
        
        if let twtToken = TwTUser.shared.token {
            headers["Authorization"] = "Bearer \(twtToken)"
        } else {
            log("can't load twtToken")
        }
        let urlString = URL(string: PracticeAPI.root + "/exercise/getScore/\(courseId)/\(time)")
        let json = dics["result"]
        let jsonData = json?.data(using: .utf8, allowLossyConversion: false)!
        guard let url = urlString else { return }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonData
    
        Alamofire.request(request).responseJSON {
            (response) in
            if response.result.isSuccess {
//                let json = JSON(response.data!)
                guard let json = response.result.value else { return }
                if let dict = json as? [String: Any] {
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
//                    let pQuizResult = PQuizResult(score: score, timestamp: timestamp, correctNum: correctNum, errNum: errorNum, notDoneNum: notDoneNum, results: pQuizResultData)
                    // FIXME: unknown API
                    let pQuizResult = PTQuizResult.init(score: score, timestamp: timestamp, correctNum: correctNum, errNum: errorNum, notDoneNum: notDoneNum, practiceTime: "", results: pQuizResultData)
                    success(pQuizResult)
                    return
                }
            } else {
                print("postQuizResult Network Error")
            }
            print("postQuizResult Network Error")
        }
    }
    
    static func getQuizQuesArray(courseId: String, success: @escaping ([PTQuizQuestion], Int) -> (), failure: (Error) -> ()) {
        SolaSessionManager.solaSession(type: .get, baseURL:  "https://exam.twtstudio.com", url: "/api/exercise/getQues/\(courseId)", success: { (data) in
            var questionArray: [PTQuizQuestion] = []
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
                    let question = PTQuizQuestion(id: id, courseId: courseId, quesType: type, content: content, options: option, isCollected: isCollceted)
                    questionArray.append(question)
                }
            }
            success(questionArray, time)
        }) { (err) in
            log(err)
        }
    }
}
