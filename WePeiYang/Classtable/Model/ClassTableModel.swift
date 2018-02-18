
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
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        term <- map["term"]
        week <- map["week"]
        termStart <- map["term_start"]
        updatedAt <- map["updated_at"]
        classes <- map["data"]
    }
}

struct TestModel: Codable {
    let week: String
    let updatedAt: String
    let termStart: Int
    let term: String
//    let classes: [ClassModel]

    enum CodingKeys: String, CodingKey {
        case week = "week"
        case term = "term"
        case termStart = "term_start"
        case updatedAt = "updated_at"
//        case classes = "data"
    }

    init(data: Data) throws {
        let a = type(of: self)
        self = try JSONDecoder().decode(a, from: data)
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else { return nil }
        try self.init(data: data)
    }
}
