//
//  TwentyCourseQuiz.swift
//  WePeiYang
//
//  Created by Allen X on 8/23/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

extension Courses.Study20 {

    struct Quiz {
        let id: String
        let belongTO: String
        let type: String
        let content: String
        let answer: String
        let isHidden: String
        let isDeleted: String
        var options: [Option]
        var userAnswer: Int?
        var chosenOnesIndexes: [Int]?

        struct Option {
            let name: String
            let weight: Int
            var wasChosen: Bool
        }
    }

    static func getQuiz(of CourseID: String, and completion: @escaping () -> Void) {
        SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: PartyAPI.courseQuizParams(of: CourseID), success: { dict in

            guard dict["status"] as? Int == 1 else {
                guard let msg = dict["msg"] as? String else {
                    SwiftMessages.showErrorMessage(body: "未知错误1")
                    //log.word("fuck2")/
                    return
                }

                SwiftMessages.showErrorMessage(body: msg)
                    //log.word("fuck1\(msg)")/
                    return
                }

                guard let fooQuizes = dict["data"] as? [NSDictionary] else {
                    SwiftMessages.showErrorMessage(body: "服务器开小差啦")
                    //log.word("fuck3")/
                    return
                }

                Courses.Study20.courseQuizes = fooQuizes.flatMap({ dict -> Quiz? in
                    guard let id = dict["exercise_id"] as? String,
                          let belongTo = dict["course_id"] as? String,
                          let type = dict["exercise_type"] as? String,
                          let content = dict["exercise_content"] as? String,
                          let answer = dict["exercise_answer"] as? String,
                          let isHidden = dict["exercise_ishidden"] as? String,
                          let isDeleted = dict["exercise_isdeleted"] as? String,
                          let fooOptions = dict["choose"] as? [[String: Any]]
                    else {
                        SwiftMessages.showErrorMessage(body: "未知错误2")
                            //log.word("fuck4")/
                            return nil
                    }

                    let options = fooOptions.flatMap({ dict -> Quiz.Option? in
                        guard let name = dict["name"] as? String,
                            let weight = dict["pos"] as? Int else {
                                return nil
                        }
                        return Quiz.Option(name: name, weight: weight, wasChosen: false)
                    })

                    guard !options.isEmpty else {
                        SwiftMessages.showErrorMessage(body: "未知错误3")
                        //log.word("fuck5")/
                        return nil
                    }

                    return Quiz(id: id, belongTO: belongTo, type: type, content: content, answer: answer, isHidden: isHidden, isDeleted: isDeleted, options: options, userAnswer: nil, chosenOnesIndexes: nil)

                })

                completion()
        }, failure: { error in
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
//            MsgDisplay.showErrorMsg("网络不好，请稍后重试")
            //log.any(err)/
        })
    }

    static func submitAnswer(of courseID: String, originalAnswer: [Int], userAnswer: [Int], and completion: @escaping () -> Void) {
        SolaSessionManager.solaSession(type: .post, baseURL: PartyAPI.courseQuizSubmitURL, url: "", token: nil, parameters: PartyAPI.courseQuizSubmitParams(of: courseID, originalAnswer: originalAnswer, userAnswer: userAnswer), success: { dict in

            log.any(PartyAPI.courseQuizSubmitParams(of: courseID, originalAnswer: originalAnswer, userAnswer: userAnswer))/

            guard let status = dict["status"] as? Int else {
                guard let msg = dict["msg"] as? String else {
                    SwiftMessages.showErrorMessage(body: "提交答案失败，别担心，等网络好了，我们会再次帮你提交一遍")

                    Courses.Study20.finalMsgAfterSubmitting = "提交答案失败，别担心，等网络好了，我们会再次帮你提交一遍"
                    Courses.Study20.finalMsgAfterSubmitting = "网络出问题啦😘"
                    Courses.Study20.finalStatusAfterSubmitting = 0

                    //log.word("fuck2")/
                    completion()
                    return
                }
                SwiftMessages.showErrorMessage(body: msg)
                Courses.Study20.finalMsgAfterSubmitting = msg
                Courses.Study20.finalStatusAfterSubmitting = 0
                log.word(msg)/
                completion()
                return
            }

            guard let msg = dict["msg"] as? String else {
                SwiftMessages.showErrorMessage(body: "网络出问题啦，别担心，等网络好了，我们会再次帮你提交一遍")
                Courses.Study20.finalMsgAfterSubmitting = "网络出问题啦，别担心，等网络好了，我们会再次帮你提交一遍"
//                MsgDisplay.showErrorMsg("网络出问题啦😘")
                Courses.Study20.finalMsgAfterSubmitting = "网络出问题啦😘"
                Courses.Study20.finalStatusAfterSubmitting = status
                completion()
                return
            }

            Courses.Study20.finalMsgAfterSubmitting = msg
            Courses.Study20.finalStatusAfterSubmitting = status

            completion()

        }, failure: { error in
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })
    }
}
