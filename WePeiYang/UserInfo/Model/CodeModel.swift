//
//  CodeModel.swift
//  WePeiYang
//
//  Created by 安宇 on 2021/1/13.
//  Copyright © 2021 twtstudio. All rights reserved.
//

import Foundation

// MARK: - Empty
struct CodeModel: Codable {
    let errorCode: Int
    let message: String
    let result: JSONNull?

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, result
    }
}
