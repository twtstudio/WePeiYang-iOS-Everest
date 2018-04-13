//
//  CollegeModel.swift
//  WePeiYang
//
//  Created by Tigris on 4/12/18.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct CollegeTopModel: Codable {
    let errorCode: Int
    let message: String
    let data: [CollegeModel]
    
    init(data: Data) throws {
        self = try JSONDecoder().decode(CollegeTopModel.self, from: data)
    }
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct CollegeModel: Codable {
    let collegeName: String
    let collegeID: Int
    
    enum CodingKeys: String, CodingKey {
        case collegeName = "college_name"
        case collegeID = "college_id"
    }
}
