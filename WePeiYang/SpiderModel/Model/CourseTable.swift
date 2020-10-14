////
////  CourseTable.swift
////  WePeiYang
////
////  Created by Shawnee on 2020/10/4.
////  Copyright © 2020 twtstudio. All rights reserved.
////
//
//import Foundation
//
//struct Arrange: Codable, Storable, Comparable {
//    let teacherArray: [String]
//    let weekArray: [Int] // 1...
//    let weekday: Int // 0...
//    let unitArray: [Int] // 0...
//    let location: String
//    
//    // Teacher
//    var teachers: String { teacherArray.joined(separator: ", ") }
//    
//    // Week
//    var firstWeek: Int { weekArray.first ?? 1 }
//    var lastWeek: Int { weekArray.last ?? 1 }
//    var weekString: String { "\(firstWeek)-\(lastWeek)" }
//    
//    // Unit
//    var startUnit: Int { unitArray.first ?? 0 }
//    var startTime: (Int, Int) {
//        [
//            (8, 30), (9, 20), (10, 25), (11, 15),
//            (13, 30), (14, 20), (15, 25), (16, 15),
//            (18, 30), (19, 20), (20, 10), (21, 0)
//        ][startUnit]
//    }
//    var startTimeString: String { String(format: "%02d:%02d", startTime.0, startTime.1) }
//    var length: Int { unitArray.count }
//    var endTime: (Int, Int) {
//        [
//            (9, 15), (10, 5), (11, 10), (12, 0),
//            (14, 15), (15, 5), (16, 10), (17, 0),
//            (19, 15), (20, 5), (20, 55), (21, 45)
//        ][startUnit + length - 1]
//    }
//    var endTimeString: String { String(format: "%02d:%02d", endTime.0, endTime.1) }
//    var unitString: String { "\(startUnit + 1)-\(startUnit + length)" }
//    var unitTimeString: String { "\(startTimeString)-\(endTimeString)" }
//    
//    var uuid: String { teachers + weekString + weekday.description + unitString + location }
//    
//    init(teacherArray: [String], weekArray: [Int], weekday: Int, unitArray: [Int], location: String) {
//        self.teacherArray = teacherArray
//        self.weekArray = weekArray
//        self.weekday = weekday
//        self.unitArray = unitArray
//        self.location = location
//    }
//    
//    init() {
//        self.teacherArray = []
//        self.weekArray = []
//        self.weekday = 0
//        self.unitArray = []
//        self.location = ""
//    }
//    
//    static func < (lhs: Arrange, rhs: Arrange) -> Bool {
//        if lhs.firstWeek != rhs.firstWeek {
//            return lhs.firstWeek < rhs.firstWeek
//        } else if lhs.weekday != rhs.weekday {
//            return lhs.weekday < rhs.weekday
//        } else if lhs.startUnit != rhs.startUnit {
//            return lhs.startUnit < rhs.startUnit
//        } else {
//            return lhs.teachers < rhs.teachers
//        }
//    }
//}
//
//struct Course: Codable, Storable {
//    
//    let serial: String
//    let no: String
//    let name: String
//    let credit: String
//    let teacherArray: [String]
//    let weeks: String
//    let campus: String
//    let arrangeArray: [Arrange]
//    
//    var teachers: String { teacherArray.joined(separator: ", ") }
//    
//    var weekRange: ClosedRange<Int> {
//        let weekArray = weeks.split(separator: "-").map { Int($0) ?? 0 }
//        return weekArray.count == 2 ? weekArray[0]...weekArray[1] : 1...1
//    }
//    
//    func activeArrange(_ weekday: Int) -> Arrange {
////        arrangeArray.filter { $0.weekday == weekday }[0]
//        arrangeArray.first { $0.weekday == weekday } ?? Arrange(teacherArray: [], weekArray: [], weekday: 0, unitArray: [], location: "")
//    }
//    
////    init(serial: String, no: String, name: String, credit: String, teacherArray: [String], weeks: String, campus: String, arrangeArray: [Arrange]) {
////        self.serial = serial
////        self.no = no
////        self.name = name
////        self.credit = credit
////        self.teacherArray = teacherArray
////        self.weeks = weeks
////        self.campus = campus
////        self.arrangeArray = arrangeArray
////    }
//    
//    init(fullCourse: [String], arrangePairArray: [(String, Arrange)]) {
//        self.serial = fullCourse[1]
//        self.no = fullCourse[2]
//        self.name = fullCourse[3]
//        self.credit = fullCourse[4]
//        self.teacherArray = fullCourse[5].split(separator: ",").map { String($0).replacingOccurrences(of: "(", with: " (") }
//        self.weeks = fullCourse[6]
//        self.campus = fullCourse[9]
//
//        var arrangeArray = [Arrange]()
//        for (name, arrange) in arrangePairArray {
//            if name == fullCourse[3] {
//                arrangeArray.append(arrange)
//            }
//        }
//        self.arrangeArray = arrangeArray
//    }
//    
//    init() {
//        self.serial = ""
//        self.no = ""
//        self.name = ""
//        self.credit = ""
//        self.teacherArray = []
//        self.weeks = ""
//        self.campus = ""
//        self.arrangeArray = []
//    }
//}
//
//struct CourseTable: Codable, Storable {
//    let courseArray: [Course]
//    
//    var totalWeek: Int {
//        courseArray.map { $0.weekRange.max() ?? 1 }.max() ?? 1
//    }
//    
//    var currentCalendar: Calendar {
//        var currentCalendar = Calendar.current
//        currentCalendar.firstWeekday = 2
//        return currentCalendar
//    }
//    var startDate: Date {
//        // TODO: Changed termly
//        // 20211
//        DateComponents(calendar: currentCalendar, year: 2020, month: 8, day: 31).date ?? Date(timeIntervalSince1970: 0)
//        // 19202
////        DateComponents(calendar: currentCalendar, year: 2020, month: 2, day: 17).date ?? Date()
//    }
//    private var endDate: Date { Date(timeInterval: TimeInterval(totalWeek * 7 * 24 * 60 * 60), since: startDate) }
//    var currentDate: Date {
//        // TODO: Dynamic calculated
//        let currentDate = Date()
//        if currentDate < startDate {
//            return startDate
//        } else if currentDate > endDate {
//            return endDate
//        } else {
//            return currentDate
//        }
//        // test date
////        DateComponents(calendar: currentCalendar, year: 2020, month: 4, day: 27, hour: 10, minute: 30).date ?? Date()
//    }
//    
//    var currentMonth: String { currentDate.format(with: "LLL") }
//    
//    var currentDay: Int { currentCalendar.component(.day, from: currentDate) }
//    
//     private var weekDistance: Double { Double(startDate.daysBetweenDate(toDate: currentDate) / 7) }
//    private var passedWeek: Double { floor(weekDistance) }
//    var currentWeek: Int { weekDistance == 0 ? 1 : Int(ceil(weekDistance)) }
//    
//    var currentWeekStartDay: Int {
//        let currentWeekStartDate = startDate.addingTimeInterval(passedWeek * 7 * 24 * 60 * 60)
//        return currentCalendar.component(.day, from: currentWeekStartDate)
//    }
//    
//    var currentWeekday: Int {
//        let weekdayDistance = weekDistance - passedWeek
//        return Int(floor(weekdayDistance * 7))
//    }
//    
//    init(courseArray: [Course]) {
//        self.courseArray = courseArray
//    }
//    
//    init() {
//        self.courseArray = []
//    }
//}
//
//extension Date {
//    func format(with format: String) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = format
//        return formatter.string(from: self)
//    }
//}
//// to pass Detail
//class AlertCourse {
//     var showDetail: Bool = false
//     var currentCourse = Course()
//     var currentWeekday = 0
//}
//
//extension Date {
//    func daysBetweenDate(toDate: Date) -> Int {
//        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
//        return components.day ?? 0
//    }
//}
