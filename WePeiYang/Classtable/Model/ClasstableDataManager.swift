//
//  ClassModel.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/13.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import ObjectMapper

struct ClasstableDataManager {

    static func getClassTable(success: @escaping (ClassTableModel) -> Void, failure: @escaping (String) -> Void) {
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
    
    static func getPopularList(success: @escaping (PopularListModel) -> Void, failure: @escaping (String) -> Void) {
        SolaSessionManager.solaSession(type: .get, url: "/auditClass/popular", parameters: nil, success: { dic in
            if let error_code = dic["error_code"] as? Int,
                error_code != -1,
                let message = dic["message"] as? String {
                failure(message)
                return
            }

            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? PopularListModel(data: data) {
                success(model)
            } else {
                failure("解析失败")
            }
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }
    
    static func getAuditDetailCourse(courseID: String, success: @escaping (AuditDetailCourseModel) -> Void, failure: @escaping (String) -> Void) {
        SolaSessionManager.solaSession(type: .get, url: "/auditClass/course", parameters: ["course_id": courseID], success: { dic in
            if let error_code = dic["error_code"] as? Int,
                error_code != -1,
                let message = dic["message"] as? String {
                failure(message)
                return
            }
            
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? AuditDetailCourseModel(data: data) {
                success(model)
            } else {
                failure("解析失败")
            }
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }
    
    static func getAllColleges(success: @escaping (AuditCollegeModel) -> Void, failure: @escaping (String) -> Void) {
        SolaSessionManager.solaSession(type: .get, url: "/auditClass/college", parameters: nil, success: { dic in
            if let error_code = dic["error_code"] as? Int,
                error_code != -1,
                let message = dic["message"] as? String {
                failure(message)
                return
            }
            
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? AuditCollegeModel(data: data) {
                success(model)
            } else {
                failure("解析失败")
            }
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }
    
    static func searchCourse(courseName: String? = nil, collegeID: String? = nil, success: @escaping (AuditSearchModel) -> Void, failure: @escaping (String) -> Void) {
        var para: [String: String] = [:]
        if let courseName = courseName {
            para["name"] = courseName
        }
        if let collegeID = collegeID {
            para["college_id"] = collegeID
        }
        
        SolaSessionManager.solaSession(type: .get, url: "/auditClass/search", parameters: para, success: { dic in
            if let error_code = dic["error_code"] as? Int,
                error_code != -1,
                let message = dic["message"] as? String {
                failure(message)
                return
            }
            
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? AuditSearchModel(data: data) {
                success(model)
            } else {
                failure("解析失败")
            }
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }
    
    static func auditCourse(schoolID: String, courseID: Int, infoIDs: [Int], success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        var dic: [String: String] = [:]
        dic["user_number"] = schoolID
        dic["course_id"] = String(courseID)
        
        guard !infoIDs.isEmpty else {
            failure("参数错误")
            return
        }
        var infoIDs = infoIDs
        dic["info_ids"] = String(infoIDs.remove(at: 0))
        infoIDs.forEach { id in
            dic["info_ids"] = dic["info_ids"]! + "," + String(id)
        }
        
        SolaSessionManager.upload(dictionay: dic, url: "/auditClass/audit", progressBlock: nil, success: { _ in
            success()
        }, failure: { err in
            failure(err.localizedDescription)
        })
    }
    
    static func deleteAuditCourse(schoolID: String, infoIDs: [Int], success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        guard !infoIDs.isEmpty else {
            failure("参数错误")
            return
        }
        var dic: [String: String] = [:]
        var infoIDs = infoIDs
        dic["ids"] = String(infoIDs.remove(at: 0))
        infoIDs.forEach { id in
            dic["ids"] = dic["ids"]! + "," + String(id)
        }
        dic["user_number"] = schoolID
        
        SolaSessionManager.upload(dictionay: dic, url: "/auditClass/audit", method: .delete, progressBlock: nil, success: { _ in
            success()
        }, failure: { err in
            failure(err.localizedDescription)
        })
        
    }
    
    static func getPersonalAuditList(success: @escaping (AuditPersonalCourseModel) -> Void, failure: @escaping (String) -> Void) {
        SolaSessionManager.solaSession(type: .get, url: "/auditClass/audit", parameters: ["user_number": "3016218106"], success: { dic in
            if let error_code = dic["error_code"] as? Int,
                error_code != -1,
                let message = dic["message"] as? String {
                failure(message)
                return
            }
            
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? AuditPersonalCourseModel(data: data) {
                success(model)
            } else {
                failure("解析失败")
            }
        }, failure: { err in
            failure(err.localizedDescription)
        })
    }
    
}
