//
//  BindingAPIs.swift
//  WePeiYang
//
//  Created by Tigris on 24/11/2017.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import Foundation

struct BindingAPIs {
    
    static let bindLIBAccount = "api/v1/auth/bind/lib"
    
    static let bindTJUAccount = "api/v1/auth/bind/tju"
    
    static let unbindLIBAccount = "api/v1/auth/unbind/lib"
    
    static let unbindTJUAccount = "api/v1/auth/unbind/tju"
    
    //MARK: Bicycle APIs
    //MARK: For users
    static let bicycleRootURL = "http://bike.twtstudio.com/api.php/"
    
    static let authURL = bicycleRootURL + "user/auth"
    
    static let cardURL = bicycleRootURL + "user/card"
    
    static let bindURL = bicycleRootURL + "user/bind"
    
    static let unBindURL = bicycleRootURL + "user/unbind"
    
    static let infoURL = bicycleRootURL + "user/info"
    
    static let recordURL = bicycleRootURL + "user/record"
    
    //MARK: For notifiaction
    static let notificationURL = bicycleRootURL + "announcement"
    
    //MARK: For stations
    static let statusURL = bicycleRootURL + "station/status"
}
