

//
//  ClassDataProvider.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/23.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation

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
    private var courses: [Int : [ClassModel]] = [:]
    
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
        
//        return (model.arrange[0].week.contains("双周") && ((Int(model.weekStart) ?? 0)...(Int(model.weekEnd) ?? 1)).contains(14)) || model.arrange[0].week == ""
//        return courses[day] ?? []
        let result = courses[day] ?? []
        return result.filter({ model in
            return (model.arrange[0].week.contains("双周") && ((Int(model.weekStart) ?? 0)...(Int(model.weekEnd) ?? 1)).contains(14)) || model.arrange[0].week == ""
        })
    }
}
