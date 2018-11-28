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
    var isPlaceholder: Bool = false

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        let transform = TransformOf<Bool, String>(fromJSON: { (value: String?) -> Bool? in
            if let value = value {
                return Bool(value)
            } else {
                return nil
            }
        }, toJSON: { (value: Bool?) -> String? in
            if let value = value {
                return String(value)
            }
            return nil
        })
        
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
        isPlaceholder <- (map["isPlaceholder"], transform)
    }

    mutating func setColorIndex(index: Int) {
        colorIndex = index
    }
}
