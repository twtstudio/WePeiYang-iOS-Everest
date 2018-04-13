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
    var record: Dictionary<String, Any>?
    
    init(dict: Dictionary<String, Any>) {
        id = dict["id"] as? String
        sign = dict["sign"] as? String
        record = dict["record"] as? Dictionary
//        action = dict["action"] as? NSNumber
//        station = dict["station"] as? NSNumber
//        dev = dict["dev"] as? NSNumber
//        time = dict["time"] as? NSNumber
    }
}

