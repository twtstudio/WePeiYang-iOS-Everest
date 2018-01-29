//
//  ClassModel.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/13.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import ObjectMapper

struct ClasstableDataManager {

    static func getClassTable(success: @escaping (ClassTableModel)->(), failure: @escaping (String)->()) {
        SolaSessionManager.solaSession(type: .get, url: "/classtable", parameters: nil, success: { dic in
            if let model = Mapper<ClassTableModel>().map(JSONObject: dic["data"]) {
                success(model)
            } else {
                failure("解析失败")
            }
            
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }
}
