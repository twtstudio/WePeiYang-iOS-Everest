//
//  PartyAPI.swift
//  WePeiYang
//
//  Created by Allen X on 8/6/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

struct PartyAPI {
    static let rootURL = "https://www.twt.edu.cn/party/"

    // Only for test
    // static let studentID: String? = "3014218099"

    static var studentID: String? {
//        let foo = UserDefaults.standard.object(forKey: "studentID") as? String
//        return foo
        return TwTUser.shared.schoolID
    }

    // 个人信息参数
    static let personalStatusParams = ["page": "api", "do": "personalstatus", "sno": studentID!]

    // 20 课简要列表，不知道 sno 要不要传
    static let courseStudyParams = ["page": "api", "do": "applicant_coursestudy", "sno": studentID!]

    static func courseStudyDetailParams(of courseID: String) -> [String: String] {
        return ["page": "api", "do": "applicant_coursestudy_detail", "course_id": courseID, "sno": studentID!]
    }

    // 20 课答题
    static func courseQuizParams(of courseID: String) -> [String: String] {
        return ["page": "api", "do": "20course_test", "course_id": courseID, "sno": studentID!]
    }

    // 20 课答案提交

    static let courseQuizSubmitURL = "https://www.twt.edu.cn/party/?page=api&do=20course_test&sno=\(studentID!)"

    static func courseQuizSubmitParams(of courseID: String, originalAnswer: [Int], userAnswer: [Int]) -> [String: String] {
        var str1 = ""
        for answer in originalAnswer {
            str1 += "\(answer), "
        }
        str1 = str1.removeCharsFromEnd(2)

        var str2 = ""
        for answer in userAnswer {
            str2 += "\(answer), "
        }
        str2 = str2.removeCharsFromEnd(2)
        return ["submit": "fuck", "course_id": courseID, "answer": str1, "exercise_answer": str2]
    }

    //预备党员党校课程学习之理论经典
    static let studyTextParams = ["page": "api", "do": "study_text"]

    static func studyTextDetailParams(of textID: String) -> [String: String] {
        return ["page": "api", "do": "study_text_article", "text_id": textID]
    }

    static let scoreInfoParams = ["page": "api", "do": "20score", "sno": studentID!]

    // MARK: 报名参数
    //结业考试报名参数
    static let applicantEntryParams = ["page": "api", "do": "applicant_entry", "sno": studentID!]
    //fuckin weird name
    static func applicantEntry2Params(of testID: String) -> [String: String] {
        return ["page": "api", "do": "applicant_entry2", "test_id": testID, "sno": studentID!]
    }

    //院级积极分子党校报名参数
    static let academyEntryParams = ["page": "api", "do": "academy_entry", "sno": studentID!]
    //fuckin weird name
    static func academyEntry2Params(of testID: String) -> [String: String] {
        return ["page": "api", "do": "academy_entry2", "test_id": testID, "sno": studentID!]
    }

    //预备党员党校报名参数
    static let probationaryEntryParams = ["page": "api", "do": "probationary_entry", "sno": studentID!]
    //fuckin weird name
    static func probationaryEntry2Params(of testID: String) -> [String: String] {
        return ["page": "api", "do": "probationary_entry2", "test_id": testID, "sno": studentID!]
    }

    static let handInURL = "https://www.twt.edu.cn/party/?page=api&do=fileupload&sno=\(studentID!)"
}

private extension String {

    func removeCharsFromEnd(_ count: Int) -> String {
        let stringLength = self.count
        let substringCount = (stringLength < count) ? 0 : stringLength - count
        let index: String.Index = self.index(self.startIndex, offsetBy: substringCount)
        return String(self[...index])
    }
}
