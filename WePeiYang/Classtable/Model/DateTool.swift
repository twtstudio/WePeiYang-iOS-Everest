//
//  DateTool.swift
//  WePeiYang
//
//  Created by Halcao on 2018/1/22.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

struct DateTool {
    //获取本周的日期数组
    static func getCurrentWeekDay() -> [String] {
        return getWeekDayAfter(weeks: 0)
    }
    
    static func getWeekDayAfter(weeks: Int) -> [String] {
        let now = Date(timeIntervalSinceNow: TimeInterval(weeks*7*24*60*60))
        var cal = Calendar.current
        // 1代表周日，2代表周一
        cal.firstWeekday = 2
        let componetSet = Set<Calendar.Component>([.year, .month, .day, .weekday])
        var components = cal.dateComponents(componetSet, from: now)
        let weekDay = components.weekday!
        
        // 计算当前日期和这周的星期一和星期天差的天数
        var mondayOffset = 0
        if weekDay == 1 {
            mondayOffset = 1-7
        } else {
            mondayOffset = cal.firstWeekday - weekDay
        }
        
        let mondayDate = now.addingTimeInterval(TimeInterval(mondayOffset*24*60*60))
        var mondayComp = cal.dateComponents(Set([.year, .month, .day]), from: mondayDate)

        let month = "\(mondayComp.month!)\n月"
        var array: [String] = []
        array.append(month)
        
        for i in 0..<7 {
            let everyDate = mondayDate.addingTimeInterval(TimeInterval(i*24*60*60))
            components = cal.dateComponents(Set([.year, .month, .day, .weekday]), from: everyDate)
            array.append(components.day!.description)
        }
        return array
    }
    
    static func getLocalWeekDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: Date())
    }
}
