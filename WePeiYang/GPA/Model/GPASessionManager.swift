//
//  GPASessionManager.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import ObjectMapper

struct GPASessionManager {
    static func getGPA(success: @escaping (GPAModel) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.solaSession(url: "/gpa", success: { dic in
            guard let errorCode = dic["error_code"] as? Int,
            let message = dic["message"] as? String else {
                failure(WPYCustomError.custom("GPA 响应解析错误"))
                return
            }
            guard errorCode == -1 else {
                failure(WPYCustomError.errorCode(errorCode, message))
                return
            }


            if let data = dic["data"] as? [String: Any], let model = Mapper<GPAModel>().map(JSON: data) {
                success(model)
            } else {
                failure(WPYCustomError.custom("GPA 数据解析错误"))
            }
        }, failure: { err in
            failure(err)
        })
    }
}
