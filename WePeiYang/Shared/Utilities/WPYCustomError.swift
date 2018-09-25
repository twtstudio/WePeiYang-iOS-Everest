//
//  WPYCustomError.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/6.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

//struct WPYCustomError: Error {
//    var description: String
//    init(_ desc: String) {
//        description = desc
//    }
//}
//extension WPYCustomError: LocalizedError {
//    var errorDescription: String? {
//        return description
//    }
//}

enum WPYCustomError: Error {
    case custom(String)
    case errorCode(Int, String)
}

extension WPYCustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .custom(let desc):
            return desc
        case .errorCode(let code, let desc):
            return desc + " 神秘代码: \(code)"
        }
    }
}

