//
//  PCourseInfoNetwork.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/10/27.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

class PCourseInfoNetwork {
    static func getCourseInfo(courseId: String, success: @escaping ([PCourseInfo]) -> (), failure: (Error) -> ()) {
        SolaSessionManager.solaSession(type: .get, baseURL: "https://exam.twtstudio.com", url: "/api/course/\(courseId)", success: { (dic) in
            var courseInfo: [PCourseInfo] = []
            if let data = dic["data"] as? [String: Any] {
                let courseName = data["course_name"] as? String ?? ""
                let singleNum = data["single_num"] as? String ?? ""
                let singleDoneNum = data["single_done_count"] as? String ?? ""
                let multiNum = data["multi_num"] as? String ?? ""
                let multiDoneNum = data["multi_done_count"] as? String ?? ""
                let decideNum = data["decide_num"] as? String ?? ""
                let decideDoneNum = data["decide_done_count"] as? String ?? ""
                let singleQuesIndex = data["single_ques_index"] as? String ?? ""
                let multiQuesIndex = data["multi_ques_index"] as? String ?? ""
                let decideQuesIndex = data["decide_ques_index"] as? String ?? ""
                
                if singleNum != "0" {
                    let singleInfo = PCourseInfo(quesType: 0, quesIndex: singleQuesIndex, quesNum: singleNum, doneNum: singleDoneNum)
                    courseInfo.append(singleInfo)
                }
                if multiNum != "0" {
                    let multiInfo = PCourseInfo(quesType: 1, quesIndex: multiQuesIndex, quesNum: multiNum, doneNum: multiDoneNum)
                    courseInfo.append(multiInfo)
                }
                if decideNum != "0" {
                    let deciedeInfo = PCourseInfo(quesType: 2, quesIndex: decideQuesIndex, quesNum: decideNum, doneNum: decideNum)
                    courseInfo.append(deciedeInfo)
                }
            }
            success(courseInfo)
        }) { (err) in
            log(err)
        }
    }
}
