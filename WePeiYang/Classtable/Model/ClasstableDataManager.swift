//
//  ClassModel.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/13.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import ObjectMapper

struct ClasstableDataManager {
    // MARK: - Service
    static func fetch(
        _ method: WPYNetwork.Method = .get,
        urlString: String,
        query: [String: String] = [:],
        body: [String: String] = [:],
        async: Bool = true,
        completion: @escaping (Result<String, WPYNetwork.Failure>) -> Void
    ) {
        WPYNetwork.fetch(urlString, query: query, method: method, body: body, async: async) { result in
            switch result {
            case .success(let (data, response)):
                guard let html = String(data: data, encoding: .utf8) else {
                    completion(.failure(.requestFailed))
                    return
                }
                
                if response.statusCode == 200, let url = response.url?.absoluteString {
                    if url.contains("https://sso.tju.edu.cn/cas/login") {
                        completion(.failure(.loginFailed))
                    } else {
                        completion(.success(html))
                    }
                } else {
                    completion(.failure(.unknownError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 获取课程表
    /// - Parameters:
    ///   - success: 成功回调
    ///   - failure: 失败回调
    static func getClassTable(success: @escaping (ClassTableModel) -> Void, failure: @escaping (Error) -> Void) {
        dataQuery { (result) in
            switch result {
            case .success(let (semesterId, hasMinor)):
                // 主修课表
                getMajorTable(semesterId: semesterId, completion: { (result) in
                    switch result {
                    case .success(let model):
                        var colorConfig = [String: Int]()
                        var newModel = model
                        newModel.classes = newModel.classes.map { course in
                            var course = course
                            if let colorIndex = colorConfig[course.courseName] {
                                course.setColorIndex(index: colorIndex)
                            } else {
                                var index = 0
                                repeat {
                                    index = Int(arc4random()) % Metadata.Color.fluentColors.count
                                    // 如果全都被选了，那也没办法
                                    if colorConfig.values.count >= Metadata.Color.fluentColors.count {
                                        break
                                    }
                                } while colorConfig.values.contains(index)
                                course.setColorIndex(index: index)
                                colorConfig[course.courseName] = index
                            }
                            return course
                        }
                        // 辅修课表
//                        if hasMinor {
//                            getMinorTable(semesterId: semesterId) { (result) in
//                                success(newModel)
//                            }
//                        }
                        success(newModel)
                        
                        
                    case .failure(let error):
                        failure(error)
                    }
                })
                
                
            case .failure(let error):
                print("ClasstableDataManager get classTable FAILED!", error)
            }
        }
    }
    
    static func dataQuery(completion: @escaping (Result<(String, Bool), WPYNetwork.Failure>) -> Void) {
        var semesterId = ""
        var hasMinor = false
        
        let queue = DispatchQueue(label: "ClassTableDataQuery")
        let semaphore = DispatchSemaphore(value: 0)
        
        // 查看是否有效
        
        queue.async {
            fetch(.post, urlString: "http://classes.tju.edu.cn/eams/dataQuery.action") { result in
                switch result {
                case .success:
                    semaphore.signal()
                case .failure(let error):
                    semaphore.signal()
                    completion(.failure(error))
                }
            }
        }
        
        // 查看学期
        queue.async {
            semaphore.wait()
            fetch(
                .post,
                urlString: "http://classes.tju.edu.cn/eams/dataQuery.action",
                body: ["dataType": "semesterCalendar"]
            ) { result in
                switch result {
                case .success(let html):
                    let allSemesters = html
                        .findArrays("id:([0-9]+),schoolYear:\"([0-9]+)-([0-9]+)\",name:\"(1|2)\"")
                        .map { Semester(semester: $0) }
                    
                    var indexPair = [Int]()
                    for (i, semester) in allSemesters.enumerated() {
                        if semester == Semester.origin || semester == Semester.current {
                            indexPair.append(i)
                        }
                    }
                    let validSemesters = allSemesters[(indexPair.first ?? 0)...(indexPair.last ?? 0)]
                    
                    semesterId = (Array(validSemesters).last ?? Semester()).id
                    semaphore.signal()
                case .failure(let error):
                    semaphore.signal()
                    completion(.failure(error))
                }
            }
        }
        
        // 查看是否有辅修
        queue.async {
            semaphore.wait()
            fetch(
                .post,
                urlString: "http://classes.tju.edu.cn/eams/dataQuery.action",
                body: ["entityId": ""]
            ) { result in
                switch result {
                case .success(let html):
                    hasMinor = html.contains("辅修")
                    semaphore.signal()
                case .failure(let error):
                    semaphore.signal()
                    completion(.failure(error))
                }
            }
        }

        queue.async {
            semaphore.wait()
            DispatchQueue.main.async {
                print("加载完毕")
                completion(.success((semesterId, hasMinor)))
            }
        }
        
    }
    
    
    /// 获取主修课表
    /// - Parameter completion: 回调函数 Result<ClassTableModel, WPYNetwork.Failure>
    static func getMajorTable(semesterId: String, completion: @escaping (Result<ClassTableModel, WPYNetwork.Failure>) -> Void) {
        
        fetch(urlString: "http://classes.tju.edu.cn/eams/courseTableForStd!innerIndex.action?projectId=1") { result in
            switch result {
            case .success(let html):
                let ids = html.find("\"ids\",\"([^\"]+)\"")
                
                fetch(
                    .post,
                    urlString: "http://classes.tju.edu.cn/eams/courseTableForStd!courseTable.action",
                    body: [
                        "ignoreHead": "1",
                        "setting.kind": "std",
                        "semester.id": semesterId,
                        "ids": ids
                    ]
                ) { result in
                    switch result {
                    case .success(let html):
                        completion(.success(parseHtml(html)))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    
    
    /// 获取辅修课表
    /// - Parameter completion: 回调函数 Result<ClassTableModel, WPYNetwork.Failure>
    static func getMinorTable(semesterId: String, completion: @escaping (Result<ClassTableModel, WPYNetwork.Failure>) -> Void) {
        var ids = ""
        var html = ""
        
        let queue = DispatchQueue(label: "ClassTableGetMinorTable")
        let semaphore = DispatchSemaphore(value: 0)
        
        // 切换projectId
        queue.async {
            fetch(urlString: "http://classes.tju.edu.cn/eams/courseTableForStd!index.action?projectId=2") { result in
                switch result {
                case .success(_):
                    semaphore.signal()
                case .failure(let error):
                    semaphore.signal()
                    completion(.failure(error))
                }
            }
        }
        
        // 获取ids
        queue.async {
            semaphore.wait()
            fetch(urlString: "http://classes.tju.edu.cn/eams/courseTableForStd!innerIndex.action?projectId=2") { result in
                switch result {
                case .success(let html):
                    ids = html.find("\"ids\",\"([^\"]+)\"")
                    semaphore.signal()
                case .failure(let error):
                    semaphore.signal()
                    completion(.failure(error))
                }
            }
        }
        
        // 获取课表
        queue.async {
            semaphore.wait()
            fetch(
                .post,
                urlString: "http://classes.tju.edu.cn/eams/courseTableForStd!courseTable.action",
                body: [
                    "ignoreHead": "1",
                    "setting.kind": "std",
                    "semester.id": semesterId,
                    "ids": ids
                ]
            ) { result in
                switch result {
                case .success(let h):
                    semaphore.signal()
                    html = h
                case .failure(let error):
                    semaphore.signal()
                    completion(.failure(error))
                }
            }
        }
        
        // 解析并返回
        queue.async {
            semaphore.wait()
            DispatchQueue.main.async {
                completion(.success(parseHtml(html)))
            }
        }
    }
    
    /// 解析html
    /// - Parameter html: html字符串
    /// - Returns: 课程表实例
    static private func parseHtml(_ html: String) -> ClassTableModel {
        // 获取课表里的课程
        let trs = html.find("<tbody(.+?)</tbody>").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "").findArray("<tr(.+?)</tr>")
        
        // 获取js代码
        let script = html.find("in TaskActivity(.+?)fillTable").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
        
        
        var courseDict: [String: ClassModel] = [:]
        var courses: [ClassModel] = []
        
        for tr in trs {
            guard tr.count > 1 else { break }
            // 一节课
            let tds = tr.findArray("<td>(.+?)</td>")
            let weeks = tds[6].split(separator: "-").map { $0.description }
            let weekStart = weeks[0]
            let weekEnd = weeks[1]
            let classID = tds[1].find(">([\\d]*)</a>")
            let campus: String = {
                if tds[9].contains("校区") {
                    return tds[9].find("(.+?)校区") + "校区"
                } else {
                    return ""
                }
            }()
            let name: String = {
                if !tds[3].contains("style") {
                    return tds[3]
                } else {
                    return tds[3].find("(.+?)<sup") + tds[3].find("\">(.+?)</s")
                }
            }()
            let credit = tds[4].contains(".") ? tds[4] : tds[4]+".0"
            
            let course = ClassModel(classID: classID,
                                    courseID: tds[2],
                                    courseName: name,
                                    courseType: "", // 暂无
                                    courseNature: "", // 暂无
                                    credit: credit,
                                    teacher: tds[5],
                                    arrange: [],
                                    weekStart: weekStart,
                                    weekEnd: weekEnd,
                                    college: "",
                                    campus: campus,
                                    ext: "", // 暂无
                                    colorIndex: 0,
                                    isPlaceholder: false,
                                    isDisplay: true,
                                    displayCourses: [],
                                    undispalyCourses: [])
            courseDict[classID] = course
        }
        
        let arrangeDict = parseJS(script)
        var removeList: [String] = []
        // 加上arrange
        for classID in courseDict.keys {
            if !arrangeDict.keys.contains(classID) {
                removeList.append(classID)
            } else {
                courseDict[classID]?.arrange = arrangeDict[classID] ?? []
            }
        }
        for classID in removeList {
            courseDict.removeValue(forKey: classID)
        }
        courses.append(contentsOf: courseDict.values)
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let date = dateFormater.date(from: "2020-8-31")
        let dateStamp: TimeInterval = date!.timeIntervalSince1970
        let dateSt:Int = Int(dateStamp)
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // TODO: 20211
        return ClassTableModel(week: "1", updatedAt: dateFormater.string(from: Date()), termStart: dateSt, term: "20211", classes: courses)
    }
    
    
    /// 解析JS
    /// - Parameter script: js字符串
    /// - Returns: 课程安排字典
    static func parseJS(_ script: String) -> [String: [ArrangeModel]] {
        var courseArrangeDict: [String: [ArrangeModel]] = [:]
        let courseList = script.components(separatedBy: "var teachers")[1...]
        //        print(courseList[0])
        for course in courseList {
            // 这节课的信息
            let lineList = course.split(separator: ";").map { $0.description }
            // 上课老师
            //            let actTeacher = lineList[1].find("name:\"(\\w+)\"")
            //            print(lineList[14])
            // 课程相关
            let courseLine = lineList[14].split(separator: ",").map { $0.description }
            // classID
            let classID = courseLine[4].find("\\((\\w+)\\)")
            // week
            let weekList = courseLine[8]
            let week: String = {
                if weekList.contains("11") {
                    return "单双周"
                } else if weekList.firstIndex(of: "1") % 2 == 1 {
                    return "单周"
                } else {
                    return "双周"
                }
            }()
            //            let weekStart = weekList.firstIndex(of: "1")
            //            let weekEnd = weekList.lastIndex(of: "1")
            // 课时间
            // 课表很神奇 下标从1开始,所以我们从1开始
            let day = (Int(lineList[15].find("=(\\d)\\*unit")) ?? 0) + 1
            let start = (Int(lineList[15].find("Count\\+(\\d)$")) ?? 0) + 1
            var end = start
            for i in stride(from: lineList.count-1, through: 15, by: -1) {
                if lineList[i].contains("unitCount") {
                    if (Int(lineList[i].find("Count\\+(\\d*)$")) ?? 0) + 1 >= start {
                        end = (Int(lineList[i].find("Count\\+(\\d*)$")) ?? 0) + 1
                    }
                    break
                }
            }
            let arrangeList = [ArrangeModel(week: week, day: day, start: start, end: end, room: courseLine[7].trimmingCharacters(in: CharacterSet(["\""])))]
            if !courseArrangeDict.keys.contains(classID) {
                courseArrangeDict[classID] = arrangeList
            } else {
                courseArrangeDict[classID]! += arrangeList
            }
        }
        return courseArrangeDict
    }
}

//MARK: - 蹭课管理
extension ClasstableDataManager {
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
        //          SolaSessionManager.solaSession(type: .get, url: "/auditClass/audit", parameters: ["user_number": TwTUser.shared.schoolID ?? ""], success: { dic in
        //               if let error_code = dic["error_code"] as? Int,
        //                  error_code != -1,
        //                  let message = dic["message"] as? String {
        //                    failure(message)
        //                    return
        //               }
        //
        //               if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let model = try? AuditPersonalCourseModel(data: data) {
        //                    success(model)
        //               } else {
        //                    failure("解析失败")
        //               }
        //          }, failure: { err in
        //               failure(err.localizedDescription)
        //          })
        success(AuditPersonalCourseModel(errorCode: 0, message: "", data: []))
    }
}
