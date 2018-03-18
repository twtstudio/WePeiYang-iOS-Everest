//
//  NotificationNames.swift
//  WePeiYang
//
//  Created by Tigris on 26/11/2017.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import Foundation

enum NotificationName: String {
    // Object thereof is a Tuple of String: Bool, which contains the name and status of binding.
    case NotificationBindingStatusDidChange

    // login success
    case NotificationUserDidLogin

    // logout success
    case NotificationUserDidLogout

    // appraise succeed
    case NotificationAppraiseDidSucceed

    // reload card
    case NotificationCardWillRefresh

    // reload card order
    case NotificationCardOrderChanged
}


extension NotificationName {
    // return a notification.name
    var name: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}
