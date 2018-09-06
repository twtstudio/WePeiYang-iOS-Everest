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

    static func getCollegeList(success: @escaping ([CollegeModel]) -> Void, failure: @escaping (String) -> Void) {
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

    static func getPopularClass(success: @escaping ([PopularClassModel]) -> Void, failure: @escaping (String) -> Void) {
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

    static func getCourseInfo(id: String, success: @escaping (AuditClassModel) -> Void, failure: @escaping (String) -> Void) {
        SolaSessionManager.solaSession(type: .get, url: "/auditClass/course", parameters: ["course_id": id], success: { dict in
            if let data = try? JSONSerialization.data(withJSONObject: dict, options: .init(rawValue: 0)),
                let response = try? AuditClassTopModel(data: data) {
                success(response.data)
            } else {
                failure("解析错误")
            }
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }

    static func addAduitCoursesLocal(courses: [ClassModel], failure: (() -> Void)? = nil) {
        CacheManager.retreive("classtable/classtable.json", from: .group, as: String.self, success: { string in
            if var table = Mapper<ClassTableModel>().map(JSONString: string) {
                var colorConfig = [String: Int]()
                table.classes.forEach { model in
                    colorConfig[model.courseName] = model.colorIndex
                }

                let newCourses: [ClassModel] = courses.map { course in
                    var course = course
                    if let colorIndex = colorConfig[course.courseName] {
                        course.setColorIndex(index: colorIndex)
                    } else {
                        // 判断是不是全部被用
                        var finalResult = false

                        for index in 0..<Metadata.Color.fluentColors.count {
                            if !colorConfig.values.contains(index) {
                                course.setColorIndex(index: index)
                                colorConfig[course.courseName] = index
                                finalResult = true
                                break
                            }
                        }

                        if !finalResult {
                            let index = Int(arc4random()) % Metadata.Color.fluentColors.count
                            course.setColorIndex(index: index)
                            colorConfig[course.courseName] = index
                        }
//                        repeat {
//                            index = Int(arc4random()) % Metadata.Color.fluentColors.count
//                        } while colorConfig.values.contains(index)
//                        course.setColorIndex(index: index)
//                        colorConfig[course.courseName] = index
                    }

                    //                    Metadata.Color.fluentColors.
                    return course
                }

                table.classes += newCourses
                table.updatedAt = Date().description
                let newString = table.toJSONString() ?? ""
                CacheManager.store(object: newString, in: .group, as: "classtable/classtable.json")
            } else {
                failure?()
            }
        }, failure: {
            failure?()
        })
    }
}
