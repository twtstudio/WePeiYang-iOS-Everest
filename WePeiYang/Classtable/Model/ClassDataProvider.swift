

//
//  ClassDataProvider.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/23.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import DateTools


class ClassDataProvider: CourseListViewDataSource {
    var table: ClassTableModel? {
        didSet {
            for day in days() {
                courses[day] = [ClassModel]()
            }

            for course in table!.classes {
                for model in course.arrange {
                    var newCourse = course
                    newCourse.arrange = [model]
                    courses[model.day]?.append(newCourse)
                }
            }
        }
    }
    func dayTitles() -> [String] {
        let dayArray = days()
        for i in dayArray {
            Calendar.current
        }
        return [""]
    }
    
    private var courses: [Int : [ClassModel]] = [:]
    
    func weekNumber() -> Int {
        guard table != nil else {
            return 0
        }
        // FIXME: Optional
//        let currentDate = Date()
        let startDate = Date(timeIntervalSince1970: TimeInterval(table!.termStart))
        let number = (startDate as NSDate).weeksAgo() + 1
        
        return number
    }
    
    func days() -> [Int] {
        guard table != nil else {
            return []
        }
        return [1, 2, 3, 4, 5, 6, 7]
    }
    
    func courses(in day: Int) -> [ClassModel] {
        guard let _ = table else {
            return []
        }
        let weekNumber = self.weekNumber()
        let isDouble = weekNumber % 2 == 0
        let hint = isDouble ? "双" : "单"
        let result = courses[day] ?? []
        return result.filter({ model in
            return (model.arrange[0].week.contains(hint) && ((Int(model.weekStart) ?? 0)...(Int(model.weekEnd) ?? 1)).contains(weekNumber)) || model.arrange[0].week == ""
        })
    }
}

