//
//  GPASessionManager.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import ObjectMapper

struct GPASessionManager {
    static func getGPA(success: @escaping (GPAModel)->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(url: "/gpa", success: { dic in
            guard let errorCode = dic["error_code"] as? Int, errorCode == -1 else {
                if let message = dic["message"] as? String {
                    failure(WPYCustomError.custom(message))
                }
                return
            }
            
            if let data = dic["data"] as? [String : Any], let model = Mapper<GPAModel>().map(JSON: data) {
                success(model)
            } else {
                // FIXME: log error
                // 数据解析失败
            }
        }, failure: { err in
            failure(err)
        })
    }
}
