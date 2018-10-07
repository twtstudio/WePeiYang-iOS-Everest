//
//  Card.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/9.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class Card: NSObject {
    var id: String?
    var sign: String?
    var record: [String: Any]?

    init(dict: [String: Any]) {
        id = dict["id"] as? String
        sign = dict["sign"] as? String
        record = dict["record"] as? Dictionary
    }
}
