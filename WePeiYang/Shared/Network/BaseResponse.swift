//
//  BaseResponse.swift
//  WePeiYang
//
//  Created by Halcao on 2018/12/30.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct BaseResponse<T>: Codable where T: Codable {
    let errorCode: Int
    let message: String
    let data: [T]

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}
