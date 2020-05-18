//
//  NameModel.swift
//  WePeiYang
//
//  Created by 安宇 on 2019/11/17.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct NameModel: Codable {
    let message: String
    let errorCode: Int
    let data: String

    enum CodingKeys: String, CodingKey {
        case message
        case errorCode = "error_code"
        case data
    }
}
