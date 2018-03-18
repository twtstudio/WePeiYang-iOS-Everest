//
//  ArrangeModel.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/13.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import ObjectMapper

private let timeArray = [(start: "8:30", end: "9:15"),
                 (start: "9:20", end: "10:05"),
                 (start: "10:25", end: "11:10"),
                 (start: "11:15", end: "12:00"),
                 (start: "13:30", end: "14:15"),
                 (start: "14:20", end: "15:05"),
                 (start: "15:25", end: "16:10"),
                 (start: "16:15", end: "17:00"),
                 (start: "18:30", end: "19:15"),
                 (start: "19:20", end: "20:05"),
                 (start: "20:10", end: "20:55"),
                 (start: "21:00", end: "21:45")]

struct ArrangeModel: Mappable {
    
    var week = ""
    var day = 0
    var start = 0
    var end = 0
    var room = ""
    var length: Int {
        return end - start + 1
    }
    var startTime: String {
        return start > 0 && start <= timeArray.count ? timeArray[start-1].start : ""
    }
    var endTime: String {
        return end > 0 && end <= timeArray.count ? timeArray[end-1].end : ""
    }

    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        let transform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
            // transform value from String? to Int?
            if let value = value {
                return Int(value)
            } else {
                return nil
            }
//            return Int(value!)
        }, toJSON: { (value: Int?) -> String? in
            // transform value from Int? to String?
            if let value = value {
                return String(value)
            }
            return nil
        })
        
        week <- map["week"]
        day <- (map["day"], transform)
        start <- (map["start"], transform)
        end <- (map["end"], transform)
        room <- map["room"]
    }
}
