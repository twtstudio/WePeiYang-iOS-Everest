//
//  ClassTableModel.swift
//  WePeiYang
//
//  Created by Halcao on 2017/11/13.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import ObjectMapper

struct ClassTableModel: Mappable {
    var week = ""
    var updatedAt = ""
    var termStart = 0
    var term = ""
    var classes: [ClassModel] = []

    init(week: String, updatedAt: String, termStart: Int, term: String, classes: [ClassModel]) {
        self.week = week
        self.updatedAt = updatedAt
        self.termStart = termStart
        self.term = term
        self.classes = classes
    }
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        term <- map["term"]
        week <- map["week"]
        termStart <- map["term_start"]
        updatedAt <- map["updated_at"]
        classes <- map["data"]
    }
}
