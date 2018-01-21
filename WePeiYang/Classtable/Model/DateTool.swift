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
        let now = Date()
        var cal = Calendar.current
        // 1代表周日，2代表周一
        cal.firstWeekday = 2
        let componetSet = Set<Calendar.Component>([.year, .month, .day, .weekday])
        let components = cal.dateComponents(componetSet, from: now)
        let weekDay = components.weekday
        let day = components.day
        
//        int 
        return []
    }
}
