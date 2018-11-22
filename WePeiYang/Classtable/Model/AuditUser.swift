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
    
    private var table: ClassTableModel?
    private var weekCourseDict: [Int: [[ClassModel]]] = [:]
    
    func update(originTable table: ClassTableModel) {
        self.table = table
        
        for i in 1...22 {
            self.weekCourseDict[i] = self.getCourse(table: table, week: i)
        }
    }
    
    
    private func getCourse(table: ClassTableModel, week: Int) -> [[ClassModel]] {
        if let dict = weekCourseDict[week] {
            return dict
        }
        // TODO: optimize
        
        var coursesForDay: [[ClassModel]] = [[], [], [], [], [], [], []]
        var classes = [] as [ClassModel]
        //        var coursesForDay: [[ClassModel]] = []
        for course in table.classes {
            // 对 week 进行判定
            // 起止周
            if week < Int(course.weekStart)! || week > Int(course.weekEnd)! {
                // TODO: turn gray
                continue
            }
            
            // 每个 arrange 变成一个
            for arrange in course.arrange {
                let day = arrange.day-1
                // 如果是实习什么的课
                if day < 0 || day > 6 {
                    continue
                }
                // 对 week 进行判定
                // 单双周
                if (week % 2 == 0 && arrange.week == "单周")
                    || (week % 2 == 1 && arrange.week == "双周") {
                    // TODO: turn gray
                    continue
                }
                
                var newCourse = course
                newCourse.arrange = [arrange]
                // TODO: 这个是啥来着?
                classes.append(newCourse)
                coursesForDay[day].append(newCourse)
            }
        }
        
        for day in 0..<7 {
            coursesForDay[day] = coursesForDay[day].sorted(by: { a, b in
                return a.arrange[0].start < b.arrange[0].start
            })
        }
        
        weekCourseDict[week] = coursesForDay
        return coursesForDay
    }
    
    
    
    
    func checkConflict(item: AuditDetailCourseItem) {
        for weekIndex in item.startWeek...item.endWeek {
            if (weekIndex % 2 == 0 && item.weekType == 1) || (week % 2 == 1 && item.weekType == 2) {
                continue
            }
            
            
            
            
        }
        
    }
    
    
    
    
    
    var collegeDic: [Int : String] = [:]
    var schoolID: String {
        return TwTUser.shared.schoolID
    }
    
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
            
        })
    }
}
