//
//  NotificationNames.swift
//  WePeiYang
//
//  Created by Tigris on 26/11/2017.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import Foundation

enum NotificationNames: String {
    case NotificationStatusDidChange
    // Object thereof is a Tuple of String: Bool, which contains the name and status of binding.
    
    var name: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}
