//
//  ClassModel.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/13.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import ObjectMapper

struct ClassModel: Mappable {
    var classID = ""
    var courseID = ""
    var courseName = ""
    var courseType = ""
    var courseNature = ""
    var credit = ""
    var teacher = ""
    var arrange: [ArrangeModel] = []
    var weekStart = ""
    var weekEnd = ""
    var college = ""
    var campus = ""
    var ext = ""
    var colorIndex = 0

    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        classID <- map["classid"]
        courseID <- map["courseid"]
        courseName <- map["coursename"]
        courseType <- map["coursetype"]
        courseNature <- map["coursenature"]
        credit <- map["credit"]
        teacher <- map["teacher"]
        arrange <- map["arrange"]
        weekStart <- map["week.start"]
        weekEnd <- map["week.end"]
        college <- map["college"]
        campus <- map["campus"]
        ext <- map["ext"]

        colorIndex <- map["colorindex"]
    }

    mutating func setColorIndex(index: Int) {
        colorIndex = index
    }

    func `class`(of day: Int) -> ClassModel? {
        var newClass = self
        newClass.arrange = arrange.filter({ $0.day == day })
        if newClass.arrange.isEmpty {
            return nil
        } else {
            return newClass
        }
    }
}

