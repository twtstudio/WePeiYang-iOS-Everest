//
//  PopularClassModel.swift
//  WePeiYang
//
//  Created by Tigris on 4/24/18.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct PopularClassTopModel: Codable {
    let errorCode: Int
    let message: String
    let data: [PopularClassModel]

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct PopularClassModel: Codable {
    let rank: Int
    let courseID, count, updatedAt: String
    let course: CustomCourseModel

    enum CodingKeys: String, CodingKey {
        case rank
        case courseID = "course_id"
        case count
        case updatedAt = "updated_at"
        case course
    }
}

struct CustomCourseModel: Codable {
    let id: Int
    let collegeID, name, year, semester: String

    enum CodingKeys: String, CodingKey {
        case id
        case collegeID = "college_id"
        case name, year, semester
    }
}
