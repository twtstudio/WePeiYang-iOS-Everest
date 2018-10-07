//
//  ApplicantTest.swift
//  WePeiYang
//
//  Created by Allen X on 8/18/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

struct ApplicantTest {

    struct ApplicantEntry {
        static var status: Int?
        static var message: String?

        static var testInfo: TestInfo?

        struct TestInfo {
            let id: String?
            let name: String?
            let beginTime: String?
            let attention: String?
            let fileName: String?
            let filePath: String?
            let status: String?
            let isDeleted: String?
            let hasEntry: Int?
        }

        static func getStatus(and completion: @escaping () -> Void) {
            SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: PartyAPI.applicantEntryParams, success: { dict in
                guard dict["status"] as? Int == 1 else {
                    guard let msg = dict["msg"] as? String else {
                        ApplicantEntry.message = "无相关信息"
                        ApplicantEntry.status = 0
                        completion()
                        return
                    }

                    ApplicantEntry.message = msg
                    ApplicantEntry.status = 0
                    completion()
                    return
                }

                ApplicantEntry.status = 1
                guard let fooInfo = dict["test_info"] as? [String: Any] else {
                    ApplicantEntry.status = 0
                    ApplicantEntry.message = "暂时无法报名"
                    completion()
                    return
                }

                guard let id = fooInfo["test_id"] as? String,
                    let name = fooInfo["test_name"] as? String,
                    let beginTime = fooInfo["test_begintime"] as? String,
                    let hasEntry = fooInfo["has_entry"] as? Int
                    else {
                        ApplicantEntry.status = 0
                        ApplicantEntry.message = "暂时无法报名"
                        completion()
                        return
                }

                let attention = fooInfo["test_attention"] as? String
                let fileName = fooInfo["test_filename"] as? String
                let filePath = fooInfo["test_filepath"] as? String
                let status = fooInfo["test_status"] as? String
                let isDeleted = fooInfo["test_isdeleted"] as? String

                ApplicantEntry.status = 1
                ApplicantEntry.message = name

                testInfo = TestInfo(id: id, name: name, beginTime: beginTime, attention: attention, fileName: fileName, filePath: filePath, status: status, isDeleted: isDeleted, hasEntry: hasEntry)

                if testInfo?.hasEntry == 1 {
                    ApplicantEntry.message = "考试时间: " + (testInfo?.beginTime)!
                } else {
                    ApplicantEntry.message = testInfo?.name
                }

                completion()
            }, failure: { _ in
                //                    MsgDisplay.showErrorMsg("出错啦！")
            })
        }

        static func signUp(forID testID: String, and completion: @escaping () -> Void) {
            //log.word("entered signUp")/
            SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: PartyAPI.applicantEntry2Params(of: testID), success: { dict in

                guard dict["status"] as? Int == 1 else {
                    guard let msg = dict["msg"] as? String else {
                        SwiftMessages.showErrorMessage(body: "报名失败，请稍后重试")
                        return
                    }
                    SwiftMessages.showErrorMessage(body: msg)
                    return
                }

                ApplicantEntry.status = 0
                guard let msg = dict["msg"] as? String else {
                    ApplicantEntry.message = "请稍候查看消息"
                    completion()
                    return
                }

                ApplicantEntry.message = msg
                completion()

            }, failure: { _ in
                SwiftMessages.showErrorMessage(body: "报名失败，请稍后重试")
            })
        }
    }

    struct AcademyEntry {

        static var status: Int?
        static var message: String?

        static var testInfo: TestInfo?

        struct TestInfo {
            let id: String?
            let name: String?
            let beginTime: String?
            let attention: String?
            let fileName: String?
            let filePath: String?
            let status: String?
            let isDeleted: String?
            let hasEntry: Int?
        }

        static func getStatus(and completion: @escaping () -> Void) {
            SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: PartyAPI.academyEntryParams, success: { dict in
                guard dict["status"] as? Int == 1 else {
                    guard let msg = dict["msg"] as? String else {
                        AcademyEntry.message = "暂时无法报名"
                        AcademyEntry.status = 0
                        completion()
                        return
                    }

                    AcademyEntry.message = msg
                    AcademyEntry.status = 0
                    completion()
                    return
                }

                guard let fooInfo = dict["test_info"] as? [String: Any] else {
                    AcademyEntry.status = 0
                    AcademyEntry.message = "暂时无法报名"
                    completion()
                    return
                }

                guard let id = fooInfo["test_id"] as? String,
                    let name = fooInfo["test_name"] as? String,
                    let beginTime = fooInfo["test_begintime"] as? String,
                    let hasEntry = fooInfo["has_entry"] as? Int
                    else {
                        AcademyEntry.status = 0
                        AcademyEntry.message = "暂时无法报名"
                        completion()
                        return
                }

                let attention = fooInfo["test_attention"] as? String
                let fileName = fooInfo["test_filename"] as? String
                let filePath = fooInfo["test_filepath"] as? String
                let status = fooInfo["test_status"] as? String
                let isDeleted = fooInfo["test_isdeleted"] as? String

                AcademyEntry.status = 1
                testInfo = TestInfo(id: id, name: name, beginTime: beginTime, attention: attention, fileName: fileName, filePath: filePath, status: status, isDeleted: isDeleted, hasEntry: hasEntry)
                if testInfo?.hasEntry == 1 {
                    AcademyEntry.message = "考试时间: " + (testInfo?.beginTime)!
                } else {
                    AcademyEntry.message = testInfo?.name
                }
                completion()
            }, failure: { _ in
                SwiftMessages.showErrorMessage(body: "出错啦！")
            })
        }

        static func signUp(forID testID: String, and completion: @escaping () -> Void) {
            SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: PartyAPI.academyEntry2Params(of: testID), success: { dict in
                guard dict["status"] as? Int == 1 else {
                    guard let msg = dict["msg"] as? String else {
                        SwiftMessages.showErrorMessage(body: "报名失败，请稍后重试")
                        return
                    }
                    SwiftMessages.showErrorMessage(body: msg)
                    return
                }

                AcademyEntry.status = 0
                guard let msg = dict["msg"] as? String else {
                    AcademyEntry.message = "请稍候查看消息"
                    completion()
                    return
                }

                AcademyEntry.message = msg

                completion()
            }, failure: { _ in
                SwiftMessages.showErrorMessage(body: "报名失败，请稍后重试")
            })
        }
    }

    struct ProbationaryEntry {

        static var status: Int?
        static var message: String?

        static var testInfo: TestInfo?

        struct TestInfo {
            let id: String?
            let name: String?
            let beginTime: String?
            let hasEntry: Int?
        }

        static func getStatus(and completion: @escaping () -> Void) {
            SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: PartyAPI.probationaryEntryParams, success: { dict in
                guard dict["status"] as? Int == 1 else {
                    guard let msg = dict["msg"] as? String else {
                        ProbationaryEntry.message = "无相关信息"
                        ProbationaryEntry.status = 0
                        completion()
                        return
                    }

                    ProbationaryEntry.message = msg
                    ProbationaryEntry.status = 0
                    completion()
                    return
                }

                guard let fooInfo = dict["test_info"] as? [String: Any] else {
                    ProbationaryEntry.status = 0
                    ProbationaryEntry.message = "暂时无法报名"
                    completion()
                    return
                }

                guard let id = fooInfo["train_id"] as? String,
                    let name = fooInfo["train_name"] as?  String,
                    let beginTime = fooInfo["train_begintime"] as? String,
                    let hasEntry = fooInfo["has_entry"] as? Int
                    else {
                        ProbationaryEntry.status = 0
                        ProbationaryEntry.message = "暂时无法报名"
                        completion()
                        return
                }

                ProbationaryEntry.status = 1
                ProbationaryEntry.message = name

                testInfo = TestInfo(id: id, name: name, beginTime: beginTime, hasEntry: hasEntry)

                if testInfo?.hasEntry == 1 {
                    ProbationaryEntry.message = "考试时间: " + (testInfo?.beginTime)!
                } else {
                    ProbationaryEntry.message = testInfo?.name
                }

                completion()
            }, failure: { _ in
//                MsgDisplay.showErrorMsg("出错啦！")
            })
        }

        static func singUp(forID trainID: String, and completion: @escaping () -> Void) {
            SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: PartyAPI.probationaryEntry2Params(of: trainID), success: { dict in
                guard dict["status"] as? Int == 1 else {
                    guard let msg = dict["msg"] as? String else {
                        SwiftMessages.showErrorMessage(body: "报名失败，请稍后重试")
                        return
                    }
                    SwiftMessages.showErrorMessage(body: msg)
                    return
                }

                ProbationaryEntry.status = 0
                guard let msg = dict["msg"] as? String else {
                    ProbationaryEntry.message = "请稍候查看消息"
                    completion()
                    return
                }

                ProbationaryEntry.message = msg

                completion()
            }, failure: { error in
                SwiftMessages.showErrorMessage(body: "报名失败，请稍后再试" + "\n" + error.localizedDescription)
            })

        }
    }
}
