
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
        score <- map["score"]
        gpa <- map["gpa"]
        credit <- map["credit"]
        year <- map["year"]
    }
}
