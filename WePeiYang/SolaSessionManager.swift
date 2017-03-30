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
    
    static func solaSession(withType type: SessionType, url: String, token: String?, parameters: Dictionary<String, String>?, success: ((Dictionary<String, AnyObject>)->())?, failure: ((Error)->())?) {
        let fullurl = TWT_ROOT_URL + url
        let timeStamp = String(Int64(Date().timeIntervalSince1970))
        var para = parameters ??  Dictionary<String, String>()
        para["t"] = timeStamp
        var fooPara = para
        
        if type == .duo && token != nil {
            fooPara["token"] = token!
        }
        
        let keys = fooPara.keys.sorted()
        // encrypt with sha1
        var tmpSign = ""
        for key in keys {
            tmpSign += (key + fooPara[key]!)
        }

        let sign = (TwTKeychain.shared.appKey + tmpSign + TwTKeychain.shared.appSecret).sha1().uppercased()
        para["sign"] = sign
        para["app_key"] = TwTKeychain.shared.appKey
        
        var headers = HTTPHeaders()
        headers["User-Agent"] = DeviceStatus.userAgentString()
        
        if type != .duo && token != nil {
            headers["Authorization"] = "Bearer {\(token!)}"
        } else if type == .duo && token != nil {
            if let twtToken = UserDefaults.standard.object(forKey: TOKEN_SAVE_KEY) as? String {
                headers["Authorization"] = "Bearer {\(twtToken)}"
            } else {
                log.errorMessage("can't load twtToken in UserDefaults!")/
            }
        }

        if type == .get {
            Alamofire.request(fullurl, parameters: para, headers: headers).responseJSON { response in
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
        } else if type == .post {
            Alamofire.request(fullurl, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
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
                    if let data = response.result.value  {
                        if let dict = data as? Dictionary<String, AnyObject> {
                            log.errorMessage(dict["message"] as! String)/
                        }
                    }
                }
            }
        } else if type == .duo {
            Alamofire.request(fullurl, method: .post, parameters: para, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
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
                    if let data = response.result.value  {
                        if let dict = data as? Dictionary<String, AnyObject> {
                            log.errorMessage(dict["message"] as! String)/
                        }
                    }
                }
            }
        }
    } // end of function
    
}
