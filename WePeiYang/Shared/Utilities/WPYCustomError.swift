//
//  WPYCustomError.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/6.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

struct WPYCustomError: Error {
    var description: String
    init(_ desc: String) {
        description = desc
    }
}
