
//
//  GPAStatModel.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import ObjectMapper

struct GPAStatModel: Mappable {
    var year: String =  "" // optional
    var score: Double = 0
    var gpa: Double = 0
    var credit: Double = 0
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        let transform = TransformOf<Double, String>(fromJSON: { value in
            if let value = value, let num = Double(value) {
                return num
            } else {
                return nil
            }
        }, toJSON: { value in
            if let value = value {
                return "\(value)"
            } else {
                return nil
            }
        })
        if map["score"].currentValue is String {
            score <- (map["score"], transform)
        } else {
            score <- map["score"]
        }
        gpa <- map["gpa"]
        credit <- map["credit"]
        year <- map["year"]
    }
}
