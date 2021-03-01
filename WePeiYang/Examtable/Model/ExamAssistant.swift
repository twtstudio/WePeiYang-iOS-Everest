//
//  ExamAssistant.swift
//  WePeiYang
//
//  Created by Halcao on 2018/12/30.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

typealias ExamTopModel = BaseResponse<[ExamModel]>
class ExamAssistant {
    static var exams: [ExamModel] = []
    static var isFinish: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-ddHH:mm"
        let currentTime = formatter.string(from: Date())

        // 没有比当前日期更大的
        return !exams.contains { model in
            return (model.date + model.arrange) > currentTime
        }
    }
    private init() {}
    
    private static func parseHtml(_ html: String) -> [ExamModel] {
        var exams: [ExamModel] = []
        let tbody = html.find("<tbody(.+?)</tbody>")
        let courses = tbody.findArray("<tr>(.+?)</tr>")
        for course in courses {
            var arr = course.findArray("<td>(.+?)</td>")
            arr = arr.map { $0.contains("color") ? $0.find(">(.+?)</font") : $0 }
            // 当没有考试的时候
            if arr.isEmpty {
                return []
            }
            let ext = arr[8] == "正常" ? "" : arr[9]
            exams.append(ExamModel(id: arr[0], name: arr[1],
                                   type: arr[2], date: arr[3],
                                   arrange: arr[5], location: arr[6],
                                   seat: arr[7], state: arr[8],
                                   ext: ext))
        }
        return exams
    }
    //OPEN被弃用
//    static func getTable(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
//        SolaSessionManager.solaSession(type: .get, url: "/examtable", token: nil, parameters: nil, success: { dic in
//            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)),
//                let res = try? ExamTopModel(data: data) {
//                ExamAssistant.exams = res.data.sorted { a, b in
//                    return (a.date + a.arrange) < (b.date + b.arrange)
//                }
//                saveCache()
//                success()
//            } else {
//                failure(WPYCustomError.custom("数据解析错误"))
//            }
//        }, failure: { err in
//            failure(err)
//        })
//    }
    static func getTable(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let urlString = "http://classes.tju.edu.cn/eams/stdExamTable!examTable.action"
        SolaSessionManager.fetch(.post, urlString: urlString) { (result) in
            switch result {
                case .success(let html):
                    ExamAssistant.exams = parseHtml(html).sorted { a, b in
                        return (a.date + a.arrange) < (b.date + b.arrange)
                    }
                    saveCache()
                    success()
                case .failure(let error):
                    failure(error)
            }
        }
    }

    static func loadCache(success: @escaping () -> (), failure: @escaping (String) -> ()) {
        CacheManager.retreive("examtable/exam.json", from: .group, as: [ExamModel].self, success: { exams in
            ExamAssistant.exams = exams
            success()
        }, failure: {
            failure("缓存加载失败")
        })
    }

    static func saveCache() {
        CacheManager.store(object: ExamAssistant.exams, in: .group, as: "examtable/exam.json")
    }
}
