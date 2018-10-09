//
//  Courses.swift
//  WePeiYang
//
//  Created by Allen X on 8/5/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

//FIXME: JSON String 类型的转换
//FIXME: Workaround For the JSON Stuff added already. Delete them in the future
import Foundation

//两种课程：
struct Courses {

    // MARK: 20 课学习资料
    static var courses: [Study20?] = []

    static func getCourseList(and completion: @escaping () -> Void) {
        SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: PartyAPI.courseStudyParams, success: { dict in
            //courselist 打错
            guard dict["status"] as? Int == 1, let fooCourses = dict["courselist"] as? [[String: Any]] else {
                SwiftMessages.showErrorMessage(body: "服务器开小差啦！")
                return
            }

            courses = fooCourses.flatMap({ dict -> Study20? in
                guard let courseID = dict["course_id"] as? String, let courseName = dict["course_name"] as? String else {
                    return nil
                }
                return Study20(courseID: courseID, courseName: courseName, courseScore: nil)
            })

            //Usually the completion is for performing tasks right after the success closure so it won't have bugs with Asynchronous stuff
            completion()
        }, failure: { error in
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })
    }

        // MARK: 20 课学习资料摘要
    struct Study20 {
        let courseID: String
        let courseName: String

        static var courseDetails: [Study20.Detail?] = []
        static var courseQuizes: [Quiz?] = []
        static var finalMsgAfterSubmitting: String?
        static var finalStatusAfterSubmitting: Int?

        var courseScore: Int?

        // MARK: 20 课学习资料详情
        struct Detail {
            let courseID: String?
            let courseName: String?
            let articleID: String?
            let articleName: String?
            let articleContent: String?
            let articleIsHidden: String?
            let articleIsDeleted: String?
            let coursePriority: String?
            let courseDetail: String?
            let courseInsertTime: String?
            let courseIsHidden: String?
            let courseIsDeleted: String?
        }

        static func getCourseDetail(of courseID: String, and completion: @escaping () -> Void) {
            SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: PartyAPI.courseStudyDetailParams(of: courseID), success: { dict in
                guard dict["status"] as? Int == 1, let fooDetails = dict["data"] as? [[String: Any]] else {
                    SwiftMessages.showErrorMessage(body: "服务器开小差啦！")
                    return
                }

                courseDetails = fooDetails.flatMap({ dict -> Detail? in
                    guard let courseID = dict["course_id"] as? String,
                        let courseName = dict["course_name"] as? String,
                        let articleID = dict["article_id"] as? String,
                        let articleName = dict["article_name"] as? String,
                        let articleContent = dict["article_content"] as? String,
                        let articleIsHidden = dict["article_ishidden"] as? String,
                        let articleIsDeleted = dict["article_isdeleted"] as? String,
                        let coursePriority = dict["course_priority"] as? String,
                        //let courseDetail = dict["course_detail"] as? String,
                        let courseInsertTime = dict["course_inserttime"] as? String,
                        let courseIsHidden = dict["course_ishidden"] as? String,
                        let courseIsDeleted = dict["course_isdeleted"] as? String
                        else {
                            return nil
                    }
                    //This let declaration is out of guard because `dict["course_detail"]` can be nil and it's OK
                    let courseDetail = dict["course_detail"] as? String

                    //Workaround for JSON type
                    //let articleIsHidden = dict["article_ishidden"] as? Bool
                    //let articleIsDeleted = dict["article_isdeleted"] as? Bool
                    //let courseInsertTime = dict["course_inserttime"] as? NSDate
                    //let courseIsHidden = dict["course_ishidden"] as? Bool
                    //let courseIsDeleted = dict["course_isdeleted"] as? Bool

                    return Detail(courseID: courseID, courseName: courseName, articleID: articleID, articleName: articleName, articleContent: articleContent, articleIsHidden: articleIsHidden, articleIsDeleted: articleIsDeleted, coursePriority: coursePriority, courseDetail: courseDetail, courseInsertTime: courseInsertTime, courseIsHidden: courseIsHidden, courseIsDeleted: courseIsDeleted)
                })

                //Usually the completion is for performing tasks right after the success closure so it won't have bugs with Asynchronous stuff
                completion()
            }, failure: { error in
                SwiftMessages.showErrorMessage(body: error.localizedDescription)
            })
        }
    }

    // MARK: 预备党员党校课程学习之理论经典

    //所有理论经典列表 static 变量
    static var texts: [StudyText?] = []

    struct StudyText {
        let fileID: String?
        let fileTitle: String?
        let fileAddTime: Date?

        struct Article {
            let fileID: String?
            let fileTitle: String?
            let fileContent: String?
            let fileAddTime: String?
            let fileType: String?
            let fileImgURL: String?
            let fileIsDeleted: String?

        }

        static var textArticle: Article?

        //获得每个理论经典的文章
        static func getTextArticle(with fileID: String, and completion: () -> Void) {
            SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: PartyAPI.studyTextDetailParams(of: fileID), success: { dict in
                //TODO: 目前不知道 filecontent 就是 String 还是 Array<NSDictionary>
                guard dict["status"] as? Int == 1, let fooArticle = dict["data"] as? [String: Any] else {
                    SwiftMessages.showErrorMessage(body: "服务器开小差啦！")
                    return
                }

                guard let fileID = fooArticle["file_id"] as? String,
                    let fileTitle = fooArticle["file_title"] as? String,
                    let fileAddTime = fooArticle["file_addtime"] as? String,
                    let fileType = fooArticle["file_type"] as? String,
                    let fileImgURL = fooArticle["file_img"] as? String,
                    let fileIsDeleted = fooArticle["file_isdeleted"] as? String
                    else {
                        return
                }
                //This let declaration is out of guard because `dict["file_content"]` can be nil and it's OK
                let fileContent = fooArticle["file_content"] as? String

                //Workaround for JSON type
                //let fileAddTime = dict["file_addtime"] as? NSDate
                //let fileIsDeleted = dict["file_isdeleted"] as? Bool

                self.textArticle = Article(fileID: fileID, fileTitle: fileTitle, fileContent: fileContent, fileAddTime: fileAddTime, fileType: fileType, fileImgURL: fileImgURL, fileIsDeleted: fileIsDeleted)
            }, failure: { error in
                SwiftMessages.showErrorMessage(body: error.localizedDescription)
            })
        }
    }

    //获得理论经典列表
    static func getTextList(and completion: @escaping () -> Void) {
        SolaSessionManager.solaSession(type: .get, baseURL: PartyAPI.rootURL, url: "", token: nil, parameters: PartyAPI.studyTextParams, success: { dict in
            guard dict["status"] as? Int == 1, let fooTexts = dict["textlist"] as? [[String: Any]] else {
                SwiftMessages.showErrorMessage(body: "服务器开小差啦！")
                return
            }

            texts = fooTexts.flatMap({ dict -> StudyText? in
                guard let fileID = dict["file_id"] as? String, let fileTitle = dict["file_title"] as? String //let fileAddTime = dict["file_addtime"] as? NSDate
                    else {
                        return nil
                }

                //Workaround for JSON type
                let fileAddTime = dict["file_addtime"] as? Date

                return StudyText(fileID: fileID, fileTitle: fileTitle, fileAddTime: fileAddTime)
            })

            //Usually the completion is for performing tasks right after the success closure so it won't have bugs with Asynchronous stuff
            completion()
        }, failure: { error in
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })
    }
}
