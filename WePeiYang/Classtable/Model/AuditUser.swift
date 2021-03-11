//
//  AuditUser.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/11/21.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

class AuditUser {
    static var shared = AuditUser()
    private init() {}
    
    var mergedTable: ClassTableModel?
    
    // 删除课程
    func deleteCourse(item: AuditDetailCourseItem, success: @escaping ([AuditDetailCourseItem]) -> Void, failure: @escaping (String) -> Void) {
        let courseID = item.courseID
        var infoIDs: [Int] = AuditCacheManager.getCourseids(withKey: courseID)
        infoIDs = infoIDs.filter { $0 != item.id }
        if infoIDs.count == 0 {
            ClasstableDataManager.deleteAuditCourse(schoolID: self.schoolID, infoIDs: [courseID], success: {
                ClasstableDataManager.getPersonalAuditList(success: { model in
                    var items: [AuditDetailCourseItem] = []
                    model.data.forEach { list in
                        items += list.infos
                    }
                    success(items)
                }, failure: { errStr in
                    failure(errStr)
                })
            }, failure: { errStr in
                failure(errStr)
            })
        } else {
            ClasstableDataManager.auditCourse(schoolID: self.schoolID, courseID: courseID, infoIDs: infoIDs, success: {
                ClasstableDataManager.getPersonalAuditList(success: { model in
                    var items: [AuditDetailCourseItem] = []
                    model.data.forEach { list in
                        items += list.infos
                    }
                    success(items)
                }, failure: { errStr in
                    failure(errStr)
                })
            }, failure: { errStr in
                failure(errStr)
            })
        }
    }
    
    // 蹭课
    func auditCourse(item: AuditDetailCourseItem, success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        let courseID = item.courseID
        var infoIDs: [Int] = AuditCacheManager.getCourseids(withKey: courseID)
        if !infoIDs.contains(item.id) {
            infoIDs.append(item.id)
        }
        
        ClasstableDataManager.auditCourse(schoolID: self.schoolID, courseID: courseID, infoIDs: infoIDs, success: {
            success()
        }, failure: { errStr in
            failure(errStr)
        })
    }
    
    // MARK: - 更新课程表
    func updateCourses(originTable table: ClassTableModel, auditCourses: [AuditDetailCourseItem] = [], isStore: Bool) {
        var table = table
        self.auditCourseSet = Set<Int>()
        
        auditCourses.forEach { item in
            var auditCourse = ClassModel(JSONString: "{\"arrange\": [{\"day\": \"\(item.weekDay)\", \"start\":\"\(item.startTime)\", \"end\":\"\(item.startTime + item.courseLength - 1)\"}], \"isPlaceholder\": \"\(false)\"}")!
            if item.weekType == 1 {
                auditCourse.arrange[0].week = "单周"
            } else if item.weekType == 2 {
                auditCourse.arrange[0].week = "双周"
            } else if item.weekType == 3 {
                auditCourse.arrange[0].week = "单双周"
            }
            auditCourse.arrange[0].day = item.weekDay
            auditCourse.arrange[0].room = item.building + "楼" + item.room
            auditCourse.courseName = "蹭∙" + item.courseName
            auditCourse.weekStart = String(item.startWeek)
            auditCourse.weekEnd = String(item.endWeek)
            //            auditCourse.teacher = item.teacher + "  " + item.teacherType
            auditCourse.teacher = item.teacher
            auditCourse.college = item.courseCollege
            auditCourse.courseID = String(-item.courseID)
            auditCourse.classID = String(-item.id)
            
            self.auditCourseSet.insert(item.id)
            table.classes.append(auditCourse)
        }
        // 配色
        var colorConfig = [String: Int]()
        table.classes = table.classes.map { course in
            var course = course
            if let colorIndex = colorConfig[course.courseID] {
                course.setColorIndex(index: colorIndex)
            } else {
                var index = 0
                repeat {
                    index = Int(arc4random()) % Metadata.Color.fluentColors.count
                } while colorConfig.values.contains(index)
                course.setColorIndex(index: index)
                colorConfig[course.courseID] = index
            }
            return course
        }
        self.mergedTable = table
        
        if UserDefaults.standard.bool(forKey: ClassTableNotificationEnabled) {
            ClassTableNotificationHelper.addNotification(table: table)
        }
        
        if isStore == true {
            let string = table.toJSONString() ?? ""
            CacheManager.store(object: string, in: .group, as: "classtable/classtable.json")
            
            let termStart = Date(timeIntervalSince1970: Double(table.termStart))
            CacheManager.saveGroupCache(with: termStart, key: "TermStart")
        }
        
        self.updateCourseTable(table: table)
    }
    
    var collegeDic: [Int: String] = [:]
    var schoolID: String { return TwTUser.shared.schoolID ?? "" }
    
    func getCollegeName(ID: Int) -> String {
        if let name = self.collegeDic[ID] {
            return name
        } else {
            return ""
        }
    }
    
    func load() {
        ClasstableDataManager.getAllColleges(success: { model in
            model.data.forEach { item in
                self.collegeDic[item.collegeID] = item.collegeName
            }
        }, failure: { errStr in
            log(errStr)
        })
    }
    
    // 检查要蹭的课程是否有冲突
    func checkConflict(item: AuditDetailCourseItem) -> Bool {
        let day = item.weekDay - 1
        for week in item.startWeek...item.endWeek {
            if (week % 2 == 0 && item.weekType == 1) || (week % 2 == 1 && item.weekType == 2) {
                continue
            }
            for i in item.startTime...(item.startTime + item.courseLength - 1) {
                let index = i - 1
                if self.conflictHashTable[84 * (week - 1) + 12 * day + index] == true {
                    return true
                }
            }
        }
        return false
    }
    
    // 全局课程表映射
    var courseMappingDic: [Int: ClassModel] = [:]
    
    // 全局课程表映射的数量
    var courseTableMax: Int {
        return self.courseMappingDic.count
    }
    
    // 检测冲突的 Hash 表    84 * week + 12 * day + index
    var conflictHashTable: [Bool] = []
    
    // 蹭课 Set
    var auditCourseSet = Set<Int>()
    
    // 课程表矩阵
    var courseTable: [[CourseList]] = Array(repeating: Array(repeating: CourseList(), count: 13), count: 8)
    
    // 更新课程表矩阵
    func updateCourseTable(table: ClassTableModel) {
        for day in 1...7 {
            for index in 1...12 {
                self.courseTable[day][index] = CourseList()
            }
        }
        self.courseMappingDic = [:]
        self.conflictHashTable = Array(repeating: false, count: 2700)
        
        for course in table.classes {
            for arrange in course.arrange {
                let day = arrange.day
                // 如果是实习什么的课
                if day < 1 || day > 7 {
                    continue
                }
                var newCourse = course
                newCourse.arrange = [arrange]
                let index = self.courseTableMax + 1
                
                self.courseMappingDic[index] = newCourse
                let courseList = self.courseTable[newCourse.arrange.first!.day][newCourse.arrange.first!.start]
                
                //                for week in 1...22 {
                for week in 1...30 {
                    if (week < Int(newCourse.weekStart)!) || (week > Int(newCourse.weekEnd)!) {
                        courseList.undisplayCourses[week].append(index)
                    } else if (week % 2 == 0 && arrange.week == "单周") || (week % 2 == 1 && arrange.week == "双周") {
                        courseList.undisplayCourses[week].append(index)
                        
                    } else {
                        courseList.displayCourses[week].append(index)
                        // 标记
                        for i in newCourse.arrange.first!.start...newCourse.arrange.first!.end {
                            let index = i - 1
                            let day = newCourse.arrange.first!.day - 1
                            self.conflictHashTable[84 * (week - 1) + 12 * day + index] = true
                        }
                    }
                }
            }
        }
    }
    
    // 返回 CourseListView 数据
    func getCourseListModel(week: Int) -> [[ClassModel]] {
        //log(self.courseTableMax)
        var classModels: [[ClassModel]] = [[], [], [], [], [], [], []]
        for day in 0...6 {
            var index: Int = 1
            while index <= 12 {
                let courseList = self.courseTable[day + 1][index]
                if courseList.displayNumber(week: week) == 0 {
                    if courseList.undisplayNumber(week: week) == 0 {
                        let placeholder = ClassModel(JSONString: "{\"arrange\": [{\"day\": \"\(day)\", \"start\":\"\(index)\", \"end\":\"\(index)\"}], \"isPlaceholder\": \"\(true)\"}")!
                        classModels[day].append(placeholder)
                        index += 1
                    } else {
                        var model = self.courseMappingDic[courseList.undisplayCourses[week].first!]!
                        model.courseName = "[非本周]" + model.courseName
                        model.isDisplay = false
                        let courseEnd = model.arrange.first!.end
                        //
                        model.undispalyCourses = courseList.undisplayCourses[week]
                        
                        if index + 1 <= model.arrange.first!.end {
                            for i in (index + 1)...model.arrange.first!.end {
                                let currentCourseList = self.courseTable[day + 1][i]
                                model.displayCourses += currentCourseList.displayCourses[week]
                                model.undispalyCourses += currentCourseList.undisplayCourses[week]
                            }
                        }
                        
                        
                        if model.displayCourses.count != 0 {
                            var currentModel = self.courseMappingDic[model.displayCourses.first!]!
                            currentModel.displayCourses = model.displayCourses
                            currentModel.undispalyCourses = model.undispalyCourses
                            model = currentModel
                            
                            for _ in index...(model.arrange.first!.start - 1) {
                                let placeholder = ClassModel(JSONString: "{\"arrange\": [{\"day\": \"\(day)\", \"start\":\"\(index)\", \"end\":\"\(index)\"}], \"isPlaceholder\": \"\(true)\"}")!
                                classModels[day].append(placeholder)
                            }
                        }
                        
                        classModels[day].append(model)
                        if model.arrange.first!.end < courseEnd {
                            for _ in (model.arrange.first!.end + 1)...courseEnd {
                                let placeholder = ClassModel(JSONString: "{\"arrange\": [{\"day\": \"\(day)\", \"start\":\"\(index)\", \"end\":\"\(index)\"}], \"isPlaceholder\": \"\(true)\"}")!
                                classModels[day].append(placeholder)
                            }
                        }
                        index = max(model.arrange.first!.end, courseEnd) + 1
                    }
                } else {
                    var model = self.courseMappingDic[courseList.displayCourses[week].first!]!
                    //
                    model.displayCourses = courseList.displayCourses[week]
                    model.undispalyCourses = courseList.undisplayCourses[week]
                    
                    if index + 1 <= model.arrange.first!.end {
                        for i in (index + 1)...model.arrange.first!.end {
                            let currentCourseList = self.courseTable[day + 1][i]
                            model.displayCourses += currentCourseList.displayCourses[week]
                            model.undispalyCourses += currentCourseList.undisplayCourses[week]
                        }
                    }
                    
                    classModels[day].append(model)
                    index = model.arrange.first!.end + 1
                }
            }
        }
        return classModels
    }
    
    func getCollectionCourses(model: ClassModel) -> [[ClassModel]] {
        var classList: [[ClassModel]] = [[], []]
        model.displayCourses.forEach { id in
            if let item = self.courseMappingDic[id] {
                classList[0].append(item)
            }
        }
        model.undispalyCourses.forEach { id in
            if var item = self.courseMappingDic[id] {
                item.courseName = "[非本周]\n" + item.courseName
                item.isDisplay = false
                classList[1].append(item)
            }
        }
        return classList
    }
    
    func getTodayCourse(table: ClassTableModel, offset: Int = 0) -> [ClassModel] {
        guard table.termStart != 0 else { return [] }
        let now = Date()
        let termStart = Date(timeIntervalSince1970: Double(table.termStart))
        let week = now.timeIntervalSince(termStart)/(7.0*24*60*60) + 1
        let currentWeek = Int(week)
        let cal = Calendar.current
        var weekday = cal.component(.weekday, from: now)
        
        // offset天以后
        weekday += offset
        weekday = (weekday - 1) % 7 + 1
        
        // 周日
        if weekday == 1 {
            weekday = 6
        } else {
            weekday -= 2
        }
        
        self.updateCourseTable(table: table)
        //        if currentWeek == 23 {
        //            currentWeek = 22
        //        }
        let courseForDay = self.getCourseListModel(week: currentWeek)
        let courses = courseForDay[weekday]
        return courses
        //        let courseForDay = getCourse(table: table, week: currentWeek)
        //        let courses = courseForDay[weekday]
        //        return courses
    }
    
}

//    func deleteCourse(infoIDs: [Int], success: @escaping ([AuditDetailCourseItem]) -> Void, failure: @escaping (String) -> Void) {
//        ClasstableDataManager.deleteAuditCourse(schoolID: self.schoolID, infoIDs: infoIDs, success: {
//            ClasstableDataManager.getPersonalAuditList(success: { model in
//                var items: [AuditDetailCourseItem] = []
//                model.data.forEach { list in
//                    items += list.infos
//                }
//
//                ClasstableDataManager.getClassTable(success: { table in
//                    AuditUser.shared.updateCourses(originTable: table, auditCourses: items, isStore: true)
//                    success(items)
//                }, failure: { errStr in
//                    failure(errStr)
//                })
//            }, failure: { errStr in
//                failure(errStr)
//            })
//        }, failure: { errStr in
//            failure(errStr)
//        })
//    }




//    func auditCourse(item: AuditDetailCourseItem, success: @escaping ([AuditDetailCourseItem]) -> Void, failure: @escaping (String) -> Void) {
//        let courseID = item.courseID
//        ClasstableDataManager.getPersonalAuditList(success: { model in
//            var infoIDs: [Int] = []
//            model.data.forEach { list in
//                list.infos.forEach { info in
//                    if courseID == info.courseID {
//                        infoIDs.append(info.id)
//                    }
//                }
//            }
//            if !infoIDs.contains(item.id) {
//                infoIDs.append(item.id)
//            }
//
//            ClasstableDataManager.auditCourse(schoolID: self.schoolID, courseID: courseID, infoIDs: infoIDs, success: {
//                ClasstableDataManager.getPersonalAuditList(success: { model in
//                    var items: [AuditDetailCourseItem] = []
//                    model.data.forEach { list in
//                        items += list.infos
//                    }
//
//                    ClasstableDataManager.getClassTable(success: { table in
//                        AuditUser.shared.updateCourses(originTable: table, auditCourses: items, isStore: true)
//                        success(items)
//                    }, failure: { errStr in
//                        failure(errStr)
//                    })
//
//                }, failure: { errStr in
//                    failure(errStr)
//                })
//            }, failure: { errStr in
//                 failure(errStr)
//            })
//        }, failure: { errStr in
//            failure(errStr)
//        })
//    }


//    func checkConflict(item: AuditDetailCourseItem) -> String? {
//        for weekIndex in item.startWeek...item.endWeek {
//            if (weekIndex % 2 == 0 && item.weekType == 1) || (weekIndex % 2 == 1 && item.weekType == 2) {
//                continue
//            }
//
//            guard let coursesForDay = self.weekCourseDict[weekIndex] else {
//                continue
//            }
//
//            let courseForSpecifiedDay = coursesForDay[item.weekDay - 1]
//            for courseIndex in 0..<courseForSpecifiedDay.count {
//                let course = courseForSpecifiedDay[courseIndex]
//                guard course.isPlaceholder == false else {
//                    continue
//                }
//
//                let startForCourse = course.arrange.first!.start
//                let endForCourse = course.arrange.first!.end
//                let startForItem = item.startTime
//                let endForItem = item.startTime + item.courseLength - 1
//                guard endForCourse < startForItem || startForCourse > endForItem else {
//                    // 冲突了
//                    if course.courseID == String(-item.id) {
//                        return "[已蹭课]"
//                    } else {
//                        return course.courseName
//                    }
//                }
//            }
//        }
//        return nil
//    }


//    private func getCourse(table: ClassTableModel, week: Int) -> [[ClassModel]] {
//        if let dict = weekCourseDict[week] {
//            return dict
//        }
//        // TODO: optimize
//
//        var coursesForDay: [[ClassModel]] = [[], [], [], [], [], [], []]
//        var classes = [] as [ClassModel]
//        //        var coursesForDay: [[ClassModel]] = []
//        for course in table.classes {
//            // 对 week 进行判定
//            // 起止周
//            if week < Int(course.weekStart)! || week > Int(course.weekEnd)! {
//                // TODO: turn gray
//                continue
//            }
//
//            // 每个 arrange 变成一个
//            for arrange in course.arrange {
//                let day = arrange.day-1
//                // 如果是实习什么的课
//                if day < 0 || day > 6 {
//                    continue
//                }
//                // 对 week 进行判定
//                // 单双周
//                if (week % 2 == 0 && arrange.week == "单周")
//                    || (week % 2 == 1 && arrange.week == "双周") {
//                    // TODO: turn gray
//                    continue
//                }
//
//                var newCourse = course
//                newCourse.arrange = [arrange]
//                // TODO: 这个是啥来着?
//                classes.append(newCourse)
//                coursesForDay[day].append(newCourse)
//            }
//        }
//
//        for day in 0..<7 {
//            var array = coursesForDay[day]
//            // 按课程开始时间排序
//            array.sort(by: { a, b in
//                return a.arrange[0].start < b.arrange[0].start
//            })
//
//            var lastEnd = 0
//            for course in array {
//                // 如果两节课之前有空格，加入长度为一的占位符
//                if (course.arrange[0].start-1) - (lastEnd+1) >= 0 {
//                    // 从上节课的结束到下节课的开始填满
//                    for i in (lastEnd+1)...(course.arrange[0].start-1) {
//                        // 构造一个假的 model
//                        let placeholder = ClassModel(JSONString: "{\"arrange\": [{\"day\": \"\(course.arrange[0].day)\", \"start\":\"\(i)\", \"end\":\"\(i)\"}], \"isPlaceholder\": \"\(true)\"}")!
//                        // placeholders[i].append(placeholder)
//                        array.append(placeholder)
//                    }
//                }
//                lastEnd = course.arrange[0].end
//            }
//            // 补下剩余的空白
//            if lastEnd < 12 {
//                for i in (lastEnd+1)...12 {
//                    // 构造一个假的 model
//                    let placeholder = ClassModel(JSONString: "{\"arrange\": [{\"day\": \"\(day)\", \"start\":\"\(i)\", \"end\":\"\(i)\"}], \"isPlaceholder\": \"\(true)\"}")!
//                    array.append(placeholder)
//                }
//            }
//            // 按开始时间进行排序
//            array.sort(by: { $0.arrange[0].start < $1.arrange[0].start })
//            coursesForDay[day] = array
//        }
//        self.weekCourseDict[week] = coursesForDay
//        return coursesForDay
//    }
