//
//  ClassTableNotificationHelper.swift
//  WePeiYang
//
//  Created by Halcao on 2018/10/9.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import UserNotifications

let ClasstableNotificationNeedsUpdateKey = "ClasstableNotificationNeedsUpdateKey"
struct ClassTableNotificationHelper {
    private init() {}

    static func addNotification(table: ClassTableModel, failure: ((String) -> Void)? = nil) {
        var messages = getMessages(with: table).sorted { a, b in
            a.date < b.date
        }

        let overflow = messages.count > 64
        UserDefaults.standard.set(overflow, forKey: ClasstableNotificationNeedsUpdateKey)

        if overflow {
            for index in 60..<messages.count {
                messages[index].msg += "\n由于 iOS 系统限制，只允许添加 64 个提醒，请打开微北洋激活更多通知，以免错过课程"
            }
            messages = Array(messages[0..<64])
        }

        removeNotification()
        if #available(iOS 10.0, *) {
            prepareForNotification(messages: messages, failure: failure)
        } else {
            prepareForNotificationOlderVersion(messages: messages, failure: failure)
        }
    }

    static func removeNotification() {
        if #available(iOS 10.0, *) {
            var identifiers = [String]()
            for i in 0..<64 {
                identifiers.append("classtable-notification-\(i)")
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        } else {
            for notification in UIApplication.shared.scheduledLocalNotifications ?? [] where notification.category == "classtable-notification" {
                UIApplication.shared.cancelLocalNotification(notification)
            }
        }
    }

    @available(iOS 10.0, *)
    static private func prepareForNotification(messages: [(date: Date, msg: String)], failure: ((String) -> Void)? = nil) {
        for (offset: i, element: (date: date, msg: body)) in messages.enumerated() {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "要上课啦"
            content.body = body
            content.sound = UNNotificationSound.default()
            content.threadIdentifier = "classtable-notification"
            // TODO: url scheme
            // content.userInfo = ["url": ""]
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "classtable-notification-\(i)", content: content, trigger: trigger)
            center.add(request, withCompletionHandler: { err in
                if let err = err {
                    failure?(err.localizedDescription)
                    log(err)
                }
            })
        }
    }

    static private func prepareForNotificationOlderVersion(messages: [(date: Date, msg: String)], failure: ((String) -> Void)? = nil) {
        for (date: date, msg: body) in messages {
            let notification = UILocalNotification()
            notification.fireDate = date
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.alertTitle = "要上课啦"
            notification.alertBody = body
            notification.category = "classtable-notification"
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }

    static private func getMessages(with table: ClassTableModel) -> [(date: Date, msg: String)] {
        let now = Date()
        let termStart = Date(timeIntervalSince1970: Double(table.termStart))
        let currentWeek = Int(now.timeIntervalSince(termStart)/(7.0*24*60*60)) + 1
        var result = [(date: Date, msg: String)]()
        for course in table.classes {
            // start from currentWeek
            let weekStart = max(Int(course.weekStart) ?? 0, currentWeek)
            let weekEnd = Int(course.weekEnd) ?? 0
            guard weekStart > 0, weekEnd > weekStart else {
                continue
            }
            for arrange in course.arrange {
                for week in weekStart...weekEnd {
                    // the right week
                    guard arrange.week == "单双周" ||
                        (week % 2 == 0 && arrange.week == "双周") ||
                        (week % 2 == 1 && arrange.week == "单周") else {
                            continue
                    }
                    let components = arrange.startTime.split(separator: ":")
                    guard let hour = Int(components[0]),
                        let min = Int(components[1]) else {
                            continue
                    }

                    let offsetMin = -15
                    let sec = ((((week-1) * 7 + arrange.day-1) * 24 + hour) * 60 + min + offsetMin) * 60
                    let date = termStart.addingTimeInterval(TimeInterval(sec))
                    guard date > now else {
                        continue
                    }

                    let body = "\(course.courseName) 将于 \(arrange.startTime) 在 \(arrange.room) 开始上课"
                    result.append((date: date, msg: body))
                }
            }
        }
        return result
    }
}
