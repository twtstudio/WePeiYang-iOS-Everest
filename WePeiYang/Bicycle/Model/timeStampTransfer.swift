//
//  timeStampTransfer.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/10.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

class timeStampTransfer: NSObject {

    static func stringFromTimeStampWithFormat(format: String, timeStampString: String) -> String {

        let second = Int(timeStampString)
        let timeStamp = NSDate(timeIntervalSince1970: Double(second!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC+8") as TimeZone!
        return dateFormatter.string(from: timeStamp as Date)
    }
}
