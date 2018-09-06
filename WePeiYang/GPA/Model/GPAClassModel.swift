//
//  GPAClassModel.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//
import ObjectMapper

struct GPAClassModel: Mappable {
    var no: Int = 0
    var name: String = ""
    var type: Int = 0
    var credit: Double = 0
    var score: Double = 0
    var reset: Int = 0
    var lessonID: String = ""
    var unionID: String = ""
    var courseID: String = ""
    var term: String = ""

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        no <- map["no"]
        name <- map["name"]
        type <- map["type"]
        score <- map["score"]
        reset <- map["reset"]
        credit <- map["credit"]

        lessonID <- map["evaluate.lesson_id"]
        unionID <- map["evaluate.union_id"]
        courseID <- map["evaluate.course_id"]
        term <- map["evaluate.term"]
    }
}
