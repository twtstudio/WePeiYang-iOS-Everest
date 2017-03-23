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

class NetworkManager {
    
    var manager: SessionManager?
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["User-Agent": "Agent"]
        manager = Alamofire.SessionManager(configuration: configuration)
    }
}

let TWT_ROOT_URL = "http://open.twtstudio.com/api/v1"
let DEV_RECORD_SESSION_INFO = "DEV_RECORD_SESSION_INFO"

struct SolaSessionManager {
    
    static func solaSession(withType type: SessionType, url: String, token: String?, parameters: Dictionary<String, String>, success: ((Any)->())?, failure: ((Error)->())?) {
        let fullurl = TWT_ROOT_URL + url
        let timeStamp = String(Int64(Date().timeIntervalSince1970))
        var para = parameters
        para["t"] = timeStamp // 1490295095 1490295220
        var fooPara = para
        
        if type == .duo && token != nil {
            fooPara["token"] = token!
        }
        
        let keys = fooPara.keys.sorted()
        // encrypt with sha1
        var str = ""
        for key in keys {
            str += (key + fooPara[key]!)
        }
        // keys.reduce("", +)
        let sign = (TwTKeychain.shared.appKey + str + TwTKeychain.shared.appSecret).sha1().uppercased()
        para["sign"] = sign
        para["app_key"] = TwTKeychain.shared.appKey
        
        let config = URLSessionConfiguration.default
        // FIXME: UserAgent
        config.httpAdditionalHeaders = ["User-Agent": "mozilla/5.0 (iphone; cpu iphone os 7_0_2 like mac os x) applewebkit/537.51.1 (khtml, like gecko) version/7.0 mobile/11a501 safari/9537.53"]
        var headers = Dictionary<String, String>()
        let manager = Alamofire.SessionManager(configuration: config)
        
        if type != .duo && token != nil {
            headers["Authorization"] = "Bearer {\(token!)}"
        } else if type == .duo && token != nil {
            if let twtToken = UserDefaults.standard.object(forKey: "twtToken") as? String {
                headers["Authorization"] = "Bearer {\(twtToken)}"
            } else {
                log.errorMessage("can't load twtToken in UserDefaults!")/
            }
        }

        if type == .get {
            Alamofire.request(fullurl, parameters: para).responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.result.value  {
                        if let dict = data as? Dictionary<String, AnyObject>, dict["error_code"] as! Int == -1 {
                            success?(dict)
                        }
                    }
                case .failure(let error):
                    failure?(error)
                    log.error(error)/
                }

            }
//            manager.request(fullurl, method: .get, parameters: para, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//                switch response.result {
//                case .success:
//                    if let json = response.result.value {
//                        success?(json)
//                    }
//                case .failure(let error):
//                    failure?(error)
//                    log.error(error)/
//                }
//                
//            }
        } else if type == .post {
            manager.request(fullurl, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    if let json = response.result.value {
                        success?(json)
                    }
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
