//
//  AuotherModel.swift
//  WePeiYang
//
//  Created by 安宇 on 2019/11/17.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct AuotherModel: Codable {
    let message: String
    let errorCode: Int
    let data: Auother

    enum CodingKeys: String, CodingKey {
        case message
        case errorCode = "error_code"
        case data
    }
}
struct Auother: Codable {
}
