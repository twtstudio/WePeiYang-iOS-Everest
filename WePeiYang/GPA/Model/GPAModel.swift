//
//  GPAModel.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/26.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import ObjectMapper

struct GPAModel: Mappable {
    var terms: [GPATermModel] = []
    var stat: GPAStatModel!
    var session: String = ""
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        terms <- map["data"]
        stat <- map["stat.total"]
        session <- map["session"]
    }
}
