//
//  Applicant.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/7.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class Applicant: NSObject {
    //FIXME: 还是需要保证数据的正确，再加载UI
    var personalStatus = [[String: Any]]()
    var scoreOf20Course = [[String: Any]]()
    var applicantGrade = [[String: Any]]()
    var academyGrade = [[String: Any]]()
    var probationaryGrade = [[String: Any]]()
    var handInHandler: [String: Any]?
    var studentNumber: String {
        return TwTUser.shared.schoolID ?? ""
    }

    static let sharedInstance = Applicant()

    fileprivate override init() {}

    func getPersonalStatus(_ doSomething: @escaping () -> Void) {

        SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: PartyAPI.personalStatusParams, success: { dict in

            guard dict["status"] as? NSNumber == 1 else {
                SwiftMessages.showErrorMessage(body: (dict["msg"] as? String) ?? "解析错误")
                return
            }

            guard let fooPersonalStatus = dict["status_id"] as? [[String: Any]] else {
                SwiftMessages.showErrorMessage(body: "获取个人状态失败，请稍后再试")
                return
            }

            self.personalStatus = fooPersonalStatus
            doSomething()
        }, failure: { error in
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })
    }

    func get20score(_ doSomething: @escaping () -> Void) {
        let parameters = ["page": "api", "do": "20score", "sno": studentNumber]

        SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: "", parameters: parameters, success: { dict in
            if dict["status"] as? NSNumber == 1 {
                self.scoreOf20Course = dict["score_info"] as! [[String: Any]]
            } else {
                SwiftMessages.showErrorMessage(body: (dict["msg"] as? String) ?? "解析错误")
                return
            }
            doSomething()
        }, failure: { error in
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })
    }

    func getGrade(_ testType: String, doSomething: @escaping () -> Void) {

        let parameters = ["page": "api", "do": "\(testType)_gradecheck", "sno": studentNumber]

        SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: parameters, success: { dic in
            guard dic["status"] as? NSNumber == 1 else {
                SwiftMessages.showErrorMessage(body: (dic["message"] as? String) ?? "解析错误")
                return
            }

            let dict = dic["data"]

            guard let fooGrade = dict as? [[String: Any]] else {
                SwiftMessages.showErrorMessage(body: "获取成绩失败，请稍后再试")
                return
            }

            if testType == "applicant" {
                self.applicantGrade = fooGrade
            } else if testType == "academy" {
                self.academyGrade = fooGrade
            } else if testType == "probationary" {
                self.probationaryGrade = fooGrade
            }

            doSomething()
        }, failure: { error in
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })
    }

    func complain(_ ID: String, testType: String, title: String, content: String, doSomething: @escaping () -> Void) {

        let parameters = ["page": "api", "do": "\(testType)_shensu", "sno": studentNumber, "test_id": ID, "title": title, "content": content]

        SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: parameters, success: { dict in

            guard dict["status"] as? NSNumber == 1 else {
                SwiftMessages.showErrorMessage(body: (dict["message"] as? String) ?? "解析错误")
                return
            }

            doSomething()
        }, failure: { error in
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })
    }

    func handIn(_ title: String, content: String, fileType: Int, doSomething: @escaping () -> Void) {
        let parameters = ["message_title": title, "message_content": content, "submit": "", "file_type": "\(fileType)"] as [String: String]

        SolaSessionManager.solaSession(type: .post, baseURL: PartyAPI.handInURL, url: "", token: nil, parameters: parameters, success: { dict in
            guard dict["status"] as? Int == 1 else {
                if let msg = dict["msg"] as? String {
                    SwiftMessages.showErrorMessage(body: msg)
                }
                return
            }

            if let msg = dict["msg"] as? String {
                SwiftMessages.showSuccessMessage(body: msg)
            } else {
                SwiftMessages.showSuccessMessage(body: "递交成功")
            }

            doSomething()
        }, failure: { error in
            SwiftMessages.showSuccessMessage(body: error.localizedDescription)
        })
    }

    func handlePersonalStatus(_ doSomething: () -> Void) {

        for dict in personalStatus {
            guard dict["status"] as? Int == 1, dict["type"] as? Int != nil else {
                continue
            }

            handInHandler = dict
            doSomething()
            return
        }

        //Nothing to hand in
        handInHandler = nil
        doSomething()
    }

}
