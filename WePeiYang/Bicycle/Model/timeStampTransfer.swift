//
//  timeStampTransfer.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/10.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class timeStampTransfer {
    static func stringFromTimeStampWithFormat(format: String, timeStampString: String) -> String {
        guard let second = Double(timeStampString) else {
            return "未知时间"
        }
        let timeStamp = NSDate(timeIntervalSince1970: second)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = (NSTimeZone(name: "UTC+8") as TimeZone?) ?? TimeZone(abbreviation: "UTC+8")
        return dateFormatter.string(from: timeStamp as Date)
    }
}
