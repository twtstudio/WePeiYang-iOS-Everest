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

let TWT_ROOT_URL = "http://open.twtstudio.com/api/v1"
let DEV_RECORD_SESSION_INFO = "DEV_RECORD_SESSION_INFO"

struct SolaSessionManager {
    
    static func solaSession(withType type: SessionType, url: String, token: String, parameters: Dictionary<String, String>, success: ((Any)->())?, failure: ((Error)->())?) {
        let fullurl = TWT_ROOT_URL + url
        let timeStamp = String(Int64(Date().timeIntervalSince1970))
        var para = parameters
        para["t"] = timeStamp
        var fooPara = para
        
        if type == .duo && !token.isEmpty {
            fooPara["token"] = token
        }
        
        let keys = fooPara.keys.sorted()
        // encrypt with sha1
        let sign = (TwTKeychain.shared.appKey + keys.reduce("", +) + TwTKeychain.shared.appSecret).sha1().uppercased()
        para["sign"] = sign
        para["app_key"] = TwTKeychain.shared.appKey
        
        let config = URLSessionConfiguration.default
        // FIXME: UserAgent
        config.httpAdditionalHeaders = ["User-Agent": "Agent"]
        var headers = Dictionary<String, String>()
        let manager = Alamofire.SessionManager(configuration: config)
        
        if type != .duo && !token.isEmpty {
            headers["Authorization"] = "Bearer {\(token)}"
        } else if type == .duo {
            if let twtToken = UserDefaults.standard.object(forKey: "twtToken") as? String {
                headers["Authorization"] = "Bearer {\(twtToken)}"
            } else {
                log.errorMessage("can't load twtToken in UserDefaults!")/
            }
        }
        
        if type == .get {
            manager.request(fullurl, method: .get, parameters: para, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    success?(response)
                case .failure(let error):
                    failure?(error)
                    log.error(error)/
                }
                
            }
        } else if type == .post {
            manager.request(fullurl, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    success?(response)
                case .failure(let error):
                    failure?(error)
                    log.error(error)/
                }
            }
        } else if type == .duo {
            manager.request(fullurl, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    success?(response)
                case .failure(let error):
                    failure?(error)
                    log.error(error)/
                }
            }
        }
    } // end of function
    
}
