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
            if let error_code = dic["error_code"] as? Int,
                error_code != -1,
                let message = dic["message"] as? String {
                    failure(message)
                return
            }

            if var model = Mapper<ClassTableModel>().map(JSONObject: dic["data"]) {
                var colorConfig = [String: Int]()
                model.classes = model.classes.map { course in
                    var course = course
                    if let colorIndex = colorConfig[course.courseName] {
                        course.setColorIndex(index: colorIndex)
                    } else {
                        var index = 0
                        repeat {
                            index = Int(arc4random()) % Metadata.Color.fluentColors.count
                        } while colorConfig.values.contains(index)
                        course.setColorIndex(index: index)
                        colorConfig[course.courseName] = index
                    }
                    
//                    Metadata.Color.fluentColors.
                    return course
                }

                success(model)
            } else {
                failure("解析失败")
            }
            
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }
    
    static func getCollegeList(success: @escaping ([CollegeModel])->(), failure: @escaping (String)->()) {
        SolaSessionManager.solaSession(type: .get, url: "/auditClass/college", parameters: nil, success: { dict in
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .init(rawValue: 0)),
                let response = try? CollegeTopModel(data: data) {
                success(response.data)
            } else {
                failure("解析错误")
            }
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }
    
    static func getPopularClass(success: @escaping ([PopularClassModel])->(), failure: @escaping (String)->()) {
        SolaSessionManager.solaSession(type: .get, url: "/auditClass/popular", parameters: nil, success: { dict in
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .init(rawValue: 0)),
                let response = try? PopularClassTopModel(data: data) {
                success(response.data)
            } else {
                failure("解析错误")
            }
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }

}

