//
//  ClassTableNotificationHelper.swift
//  WePeiYang
//
//  Created by Halcao on 2018/10/9.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import UserNotifications

struct ClassTableNotificationHelper {
    private init() {}

    static func addNotification(table: ClassTableModel) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["classtable-notification"])
        } else {
            // Fallback on earlier versions
        }

        let termStart = Date(timeIntervalSince1970: Double(table.termStart))
        let currentWeek = Int(Date().timeIntervalSince(termStart)/(7.0*24*60*60)) + 1
        for course in table.classes {
            for arrange in course.arrange {
                if let weekStart = Int(course.weekStart),
                    let weekEnd = Int(course.weekEnd) {
                    for week in weekStart...weekEnd where
                        week >= currentWeek &&
                            (arrange.week == "单双周" ||
                                (week % 2 == 0 && arrange.week == "双周") ||
                                (week % 2 == 1 && arrange.week == "单周")) {
                        let components = arrange.startTime.split(separator: ":")
                        if let hour = Int(components[0]),
                        let min = Int(components[1]) {
                            // TODO: offset
                            let date = getDate(termStart: table.termStart, week: week, day: arrange.day, hour: hour, min: min, offsetMin: -15)
                            let timeIntervalSinceNow = date.timeIntervalSinceNow
                            if timeIntervalSinceNow < 1 {
                                continue
                            }
                            if #available(iOS 10.0, *) {
                                let center = UNUserNotificationCenter.current()
                                let content = UNMutableNotificationContent()
                                content.title = "要上课啦"
                                content.body = "\(course.courseName) 将于 \(arrange.startTime) 在 \(arrange.room) 开始上课"
                                content.sound = UNNotificationSound.default()
                                content.threadIdentifier = "classtable-notification"
                                // TODO: url scheme
                                // content.userInfo = ["url": ""]
                                if #available(iOS 12.0, *) {
                                    content.summaryArgument = "还有 %u 个更多课程"
                                }
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeIntervalSinceNow, repeats: false)
                                let request = UNNotificationRequest(identifier: "classtable-notification", content: content, trigger: trigger)
                                center.add(request, withCompletionHandler: { err in
                                    if let err = err {
                                        log.error(err)/
                                    }
                                })
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                }
            }
        }
    }

    // seconds from now to week/day/hour+offsetMin/sec
    private static func getDate(termStart: Int, week: Int, day: Int, hour: Int, min: Int, offsetMin: Int) -> Date {
        let sec = termStart + ((((week-1) * 7 + day-1) * 24 + hour) * 60 + min + offsetMin) * 60
        return Date(timeIntervalSince1970: TimeInterval(sec))
    }
}
