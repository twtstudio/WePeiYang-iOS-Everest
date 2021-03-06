//
//  Semester.swift
//  WePeiYang
//
//  Created by Shawnee on 2020/10/4.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation

struct Semester: Codable, Equatable {
    let id: String
    let begin: String
    let end: String
    let name: String
    
    var fullname: String { "\(begin)-\(end) \(name)" }
    
    static var origin: Semester {
        var begin = "20" // crazy if using this a century later
        for (i, scalar) in AccountManager.username.enumerated() {
            if (2...3).contains(i) {
                begin.append(scalar)
            }
        }

        return Semester(begin: begin, end: String((Int(begin) ?? 0) + 1), name: "1")
    }
    
    static var current: Semester {
        let today = Date()
        let current = Calendar.current
        let year = current.component(.year, from: today)
        let month = current.component(.month, from: today)
        
        // TODO: Changed after finishing debug
        if month > 7 {
//        if month > 8 {
            return Semester(begin: String(year), end: String(year + 1), name: "1")
        } else if month < 2 {
            return Semester(begin: String(year - 1), end: String(year), name: "1")
        } else {
            return Semester(begin: String(year - 1), end: String(year), name: "2")
        }
    }
    
//    init(id: String, begin: String, end: String, name: String) {
//        self.id = id
//        self.begin = begin
//        self.end = end
//        self.name = name
//    }
    
    /// Initialize with no `id`, using for static variable before fetching from server
    /// - Parameters:
    ///   - begin: begin year
    ///   - end: end year
    ///   - name: two semesters marked as `1` and `2`
    init(begin: String, end: String, name: String) {
        self.id = ""
        self.begin = begin
        self.end = end
        self.name = name
    }
    
    /// Initialize with `semester` scratched from server, each property will be setted in order
    /// - Parameter semester: semester array
    init(semester: [String]) {
        self.id = semester[1]
        self.begin = semester[2]
        self.end = semester[3]
        self.name = semester[4]
    }
    
    init() {
        self.id = ""
        self.begin = ""
        self.end = ""
        self.name = ""
    }
    
    static func == (lhs: Semester, rhs: Semester) -> Bool { lhs.fullname == rhs.fullname }
}
