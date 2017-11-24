//
//  ArrangeModel.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/13.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import ObjectMapper

struct ArrangeModel: Mappable {
    
    var week = ""
    var day = 0
    var start = 0
    var end = 0
    var room = ""
    var length: Int {
        return end - start + 1
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
