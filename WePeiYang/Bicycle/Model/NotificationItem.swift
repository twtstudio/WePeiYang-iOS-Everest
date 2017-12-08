//
//  NotificationItem.swift
//  WePeiYang
//
//  Created by Tigris on 19/08/2017.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import Foundation

class NotificationItem: NSObject {
    
    var id: String = "" //坑：类型
    var title: String = ""
    var content: String = ""
    var timeStamp: NSDate = NSDate()
    var second: Int = 0
    
    init(dict: NSDictionary) {
        
        id = dict.object(forKey: "id") as! String
        title = dict.object(forKey: "title") as! String
        content = dict.object(forKey: "content") as! String
        
        let timeStampString = dict.object(forKey: "timestamp") as? String
        second = Int(timeStampString!)!
        timeStamp = NSDate(timeIntervalSince1970: Double(second))
    }
    
}

