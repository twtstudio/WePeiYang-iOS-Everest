//
//  SolaSessionManager.swift
//  WePeiYang
//
//  Created by Halcao on 2017/3/12.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

enum SessionType {
    case get
    case post
    case duo
}

let TWT_ROOT_URL = "https://open.twtstudio.com/api/v1"
let DEV_RECORD_SESSION_INFO = "DEV_RECORD_SESSION_INFO"

struct SolaSessionManager {
    
    /// A primary package of Alamofire, the foundation of network module of WePeiyang
    ///
    /// - Parameters:
    ///   - type: http method: get/post/duo, default value is get
    ///   - baseURL: base url of your request, default value is TWT_ROOT_URL
    ///   - url: url of your request
    ///   - token: default value is twt token
    ///   - parameters: http parameters
    ///   - success: callback if request succeeds
    ///   - failure: callback if request fails
    static func solaSession(type: SessionType = .get, baseURL: String = TWT_ROOT_URL, url: String, token: String? = nil, parameters: Dictionary<String, String>? = nil, success: ((Dictionary<String, AnyObject>)->())? = nil, failure: ((Error)->())? = nil) {
        
        let fullurl = baseURL + url
        let timeStamp = String(Int64(Date().timeIntervalSince1970))
        var para = parameters ?? Dictionary<String, String>()
        para["t"] = timeStamp
        var fooPara = para
        
        if type == .duo {
            if let twtToken = TwTUser.shared.token {
                // twt token
                fooPara["token"] = twtToken
            }
        }
        
        let keys = fooPara.keys.sorted()
        // encrypt with sha1
        var tmpSign = ""
        for key in keys {
            tmpSign += (key + fooPara[key]!)
        }

        let sign = (TwTKeychain.shared.appKey + tmpSign + TwTKeychain.shared.appSecret).sha1.uppercased()
        para["sign"] = sign
        para["app_key"] = TwTKeychain.shared.appKey
        
        var headers = HTTPHeaders()
        headers["User-Agent"] = DeviceStatus.userAgent
        
        TwTUser.shared.token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjc4NjksImlzcyI6Imh0dHA6XC9cL29wZW4udHd0c3R1ZGlvLmNvbVwvYXBpXC92MVwvYXV0aFwvdG9rZW5cL3JlZnJlc2giLCJpYXQiOjE1MDQyMzQ0MjAsImV4cCI6MTUwNTQ2MTcxNCwibmJmIjoxNTA0ODU2OTE0LCJqdGkiOiJmZjgwZmIxNDMxMGRiNzRhN2ExNTRiM2ZlODYxZjRlYiJ9.T6ynlh9Oe-7Z-V3o2XNi7I1foYwfdlshOsU6QgdJ58E"
        if let twtToken = TwTUser.shared.token {
            headers["Authorization"] = "Bearer {\(twtToken)}"
        } else {
            log.errorMessage("can't load twtToken")/
        }
        
        if type == .duo && token != nil{
            headers["Authorization"] = "Bearer {\(token)}"
        }
        var method: HTTPMethod!
        switch type {
        case .get:
            method = .get
        case .post:
            method = .post
        case .duo:
            method = .post
        }
        
        Alamofire.request(fullurl, method: method, parameters: para, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value  {
                    if let dict = data as? Dictionary<String, AnyObject> {
                        success?(dict)
                    }
                }
            case .failure(let error):
                failure?(error)
                log.error(error)/
                if let data = response.result.value  {
                    if let dict = data as? Dictionary<String, AnyObject> {
                        log.errorMessage(dict["message"] as! String)/
                    }
                }
            }
            
        }
    }
}
