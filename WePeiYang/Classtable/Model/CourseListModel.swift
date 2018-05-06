//
//  CourseListModel.swift
//  WePeiYang
//
//  Created by Tigris on 4/24/18.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct AuditCourseInfo: Codable {
    let errorCode: Int
    let message: String
    let data: [Datum]
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct Datum: Codable {
    let id: Int
    let collegeID, name, year, semester: String
    let college: College
    let info: [Info]
    
    enum CodingKeys: String, CodingKey {
        case id
        case collegeID = "college_id"
        case name, year, semester, college, info
    }
}

struct College: Codable {
    let id: Int
    let name: String
}

struct Info: Codable {
    let id: Int
    let courseID, courseName, courseIDInTju, startWeek: String
    let endWeek, startTime, courseLength, weekDay: String
    let weekType, building, room, teacherType: String
    let teacher: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseID = "course_id"
        case courseName = "course_name"
        case courseIDInTju = "course_id_in_tju"
        case startWeek = "start_week"
        case endWeek = "end_week"
        case startTime = "start_time"
        case courseLength = "course_length"
        case weekDay = "week_day"
        case weekType = "week_type"
        case building, room
        case teacherType = "teacher_type"
        case teacher
    }
}
