//
//  ExamAssistant.swift
//  WePeiYang
//
//  Created by Halcao on 2018/12/30.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

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

    static func getTable(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        SolaSessionManager.solaSession(type: .get, url: "/examtable", token: nil, parameters: nil, success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)),
                let res = try? ExamTopModel(data: data) {
                ExamAssistant.exams = res.data.sorted { a, b in
                    return (a.date + a.arrange) < (b.date + b.arrange)
                }
                saveCache()
                success()
            } else {
                failure(WPYCustomError.custom("数据解析错误"))
            }
        }, failure: { err in
            failure(err)
        })
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
