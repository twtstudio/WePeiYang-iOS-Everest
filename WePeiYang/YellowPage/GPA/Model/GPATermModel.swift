

//
//  GPATermModel.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import ObjectMapper

struct GPATermModel: Mappable {
    var term: String = ""
    var classes: [GPAClassModel] = []
    var name: String = ""
    var stat: GPAStatModel!
    
    init?(map: Map) {}
    mutating func mapping(map: Map) {
        term <- map["term"]
        classes <- map["data"]
        name <- map["name"]
        stat <- map["stat"]
    }
}
