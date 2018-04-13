//
//  BicycleAPIs.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/9.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation

struct BicycleAPIs {
    
    //MARK: For users
    static let rootURL = "https://bike.twtstudio.com/api.php/"
    
    static let authURL = "user/auth"
    
    static let cardURL = "user/card"
    
    static let bindURL = "user/bind"
    
    static let unBindURL = "user/unbind"
    
    static let infoURL = "user/info"
    
    static let recordURL = "user/record"
    
    //MARK: For notifiaction
    static let notificationURL = "announcement"
    
    //MARK: For stations
    static let statusURL = "station/status"
    
    //Deleted all 'rootURL's in branch urls due to new solaSession method.
}

