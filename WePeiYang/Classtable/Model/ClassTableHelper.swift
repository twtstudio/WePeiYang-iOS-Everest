//
//  ClassTableHelper.swift
//  WePeiYang
//
//  Created by Halcao on 2018/1/27.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation
import ObjectMapper

struct ClassTableHelper {
    static func getTodayCourse(table: ClassTableModel, offset: Int = 0) -> [ClassModel] {
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
        let courseForDay = getCourse(table: table, week: currentWeek)
        let courses = courseForDay[weekday]
        return courses
    }

    // 很尴尬 我会优化的
    static func getCourse(table: ClassTableModel, week: Int) -> [[ClassModel]] {

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
            var array = coursesForDay[day]
            // 按课程开始时间排序
            array.sort(by: { a, b in
                return a.arrange[0].start < b.arrange[0].start
            })

            var lastEnd = 0
            for course in array {
                // 如果两节课之前有空格，加入长度为一的占位符
                if (course.arrange[0].start-1) - (lastEnd+1) >= 0 {
                    // 从上节课的结束到下节课的开始填满
                    for i in (lastEnd+1)...(course.arrange[0].start-1) {
                        // 构造一个假的 model
                        let placeholder = ClassModel(JSONString: "{\"arrange\": [{\"day\": \"\(course.arrange[0].day)\", \"start\":\"\(i)\", \"end\":\"\(i)\"}]}")!
                        // placeholders[i].append(placeholder)
                        array.append(placeholder)
                    }
                    //                    for i in (lastEnd+1)..<(course.arrange[0].start-1) {
                    //                        // 构造一个假的 model
                    //                        let placeholder = ClassModel(JSONString: "{\"arrange\": [{\"day\": \"\(course.arrange[0].day)\", \"start\":\"\(i)\", \"end\":\"\(i+1)\"}]}")!
                    //                        // placeholders[i].append(placeholder)
                    //                        array.append(placeholder)
                    //                    }
                }
                lastEnd = course.arrange[0].end
            }
            // 补下剩余的空白
            if lastEnd < 12 {
                for i in (lastEnd+1)...12 {
                    // 构造一个假的 model
                    let placeholder = ClassModel(JSONString: "{\"arrange\": [{\"day\": \"\(day)\", \"start\":\"\(i)\", \"end\":\"\(i)\"}]}")!
                    // placeholders[i].append(placeholder)
                    array.append(placeholder)
                }
            }
            // 按开始时间进行排序
            array.sort(by: { $0.arrange[0].start < $1.arrange[0].start })
            coursesForDay[day] = array
        }
        return coursesForDay
    }
}
