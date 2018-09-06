//
//  CourseListModel.swift
//  WePeiYang
//
//  Created by Tigris on 4/24/18.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct AuditClassTopModel: Codable {
    let errorCode: Int
    let message: String
    let data: AuditClassModel

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

private let WeekTypeDic = [
    "1": "双周",
    "2": "单周",
    "3": "单双周"
]
// weekType:
// FIXME: 假设！
// 1:
// 2:
// 3:单双周

struct AuditClassModel: Codable {
    let id: Int
    let collegeID: String
    let name: String
    let year: String
    let semester: String
    let college: String
    let infos: [AuditClassInfoModel]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case collegeID = "college_id"
        case name = "name"
        case year = "year"
        case semester = "semester"
        case college = "college"
        case infos = "info"
    }

    func toClassModel() -> [ClassModel] {

////        var week = ""
////        var day = 0
////        var start = 0
////        var end = 0
////        var room = ""
        var result = [ClassModel]()

        for info in infos {
            let dic: [String: Any] = [//"classid": info.courseID,
                "courseid": info.courseIDInTju,
                "coursename": info.courseName,
//                "coursetype": info.type
//                "coursenature":
//                "credit":
                "teacher": info.teacher + " " + info.teacherType,
                "week": [
                    "start": info.startWeek,
                    "end": info.endWeek
                    ],
                "college": college
            ]
            let endTime = String(Int(info.startTime)! + Int(info.courseLength)! - 1)
            let arrangeDic = [
                "week": WeekTypeDic[info.weekType] ?? "单双周",
                "day": info.weekDay,
                "start": info.startTime,
                "end": endTime,
                "room": info.building + info.room
            ]
            if var model = ClassModel(JSON: dic),
                let arrange = ArrangeModel(JSON: arrangeDic) {
                model.arrange.append(arrange)
                result.append(model)
            }
        }
        return result
    }
}

struct AuditClassInfoModel: Codable {
    let id: Int
    let courseID: String
    let courseName: String
    let courseIDInTju: String
    let startWeek: String
    let endWeek: String
    let startTime: String
    let courseLength: String
    let weekDay: String
    let weekType: String
    let building: String
    let room: String
    let teacherType: String
    let teacher: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case courseID = "course_id"
        case courseName = "course_name"
        case courseIDInTju = "course_id_in_tju"
        case startWeek = "start_week"
        case endWeek = "end_week"
        case startTime = "start_time"
        case courseLength = "course_length"
        case weekDay = "week_day"
        case weekType = "week_type"
        case building = "building"
        case room = "room"
        case teacherType = "teacher_type"
        case teacher = "teacher"
    }
}
