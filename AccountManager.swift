
//
//  AccountManager.swift
//  WePeiYang
//
//  Created by Halcao on 2017/3/23.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation

let TOKEN_SAVE_KEY = "twtToken"
let ID_SAVE_KEY = "twtId"
let TJU_BIND_KEY = "bindTju"
let CLASSTABLE_CACHE_KEY = "CLASSTABLE_CACHE"
let CLASSTABLE_COLOR_CONFIG_KEY = "CLASSTABLE_COLOR_CONFIG"
let CLASSTABLE_TERM_START_KEY = "CLASSTABLE_TERM_START"
let GPA_CACHE = "gpaCache"
let GPA_USER_NAME_CACHE = "gpaUserNameAndPassword"
let ALLOW_SPOTLIGHT_KEY = "allowSpotlightIndex"


struct AccountManager {
    
    static func tokenExists() -> Bool {
        if UserDefaults.standard.object(forKey: TOKEN_SAVE_KEY) != nil {
            return true
        } else {
            return false
        }
    }
    
    static func removeToken() {
        UserDefaults.standard.removeObject(forKey: TOKEN_SAVE_KEY)
        UserDefaults.standard.removeObject(forKey: ID_SAVE_KEY)
        UserDefaults.standard.removeObject(forKey: "readToken")

        CacheManager.removeCache(withKey: GPA_CACHE)
        CacheManager.removeGroupCache(withKey: CLASSTABLE_TERM_START_KEY)
        CacheManager.removeGroupCache(withKey: CLASSTABLE_CACHE_KEY)
        CacheManager.removeGroupCache(withKey: CLASSTABLE_COLOR_CONFIG_KEY)
        TwTKeychain.shared.token = ""
        // TODO: CSSearchable
    }
    
    static func getToken(username: String, password: String, success: (()->())?, failure: ((Error)->())?) {
        let para: Dictionary<String, String> = ["twtuname": username, "twtpasswd": password]
        SolaSessionManager.solaSession(withType: .get, url: "/auth/token/get", token: nil, parameters: para, success: { dic in
            if let data = dic["data"] as? Dictionary<String, AnyObject> {
                if let token = data["token"] as? String {
                    UserDefaults.standard.setValue(token, forKey: TOKEN_SAVE_KEY)
                    UserDefaults.standard.setValue(username, forKey: ID_SAVE_KEY)
                    TwTKeychain.shared.token = token
                    success?()
                }
            }
            
        }, failure: { error in
            failure?(error)
        })
        
    }
    
    static func checkToken(success: (()->())?, failure: (()->())?) {
        guard let token = UserDefaults.standard.object(forKey: TOKEN_SAVE_KEY) as? String else {
            failure?()
            log.errorMessage("token不存在")/
            return
        }
        
        SolaSessionManager.solaSession(withType: .get, url: "/auth/token/check", token: token, parameters: nil, success: { dict in
            if let error_code = dict["error_code"] as? Int {
                if error_code == -1 {
                    success?()
                } else if error_code == 10003 { // 过期
                    // refresh token
                    SolaSessionManager.solaSession(withType: .get, url: "/auth/token/refresh", token: token, parameters: nil, success: { dict in
                        if let newToken = dict["data"] as? String {
                            UserDefaults.standard.setValue(newToken, forKey: TOKEN_SAVE_KEY)
                            success?()
                            return
                        }
                        if let msg = dict["message"] as? String {
                            log.word(msg)/
                        }
                    }, failure: { error in
                        log.error(error)/
                        failure?()
                        self.removeToken()
                    }) // refresh finished

                } else if let msg = dict["message"] as? String { // check failed
                    failure?()
                    log.errorMessage(msg)/
                    self.removeToken()
                } else {
                    failure?()
                    self.removeToken()
                }
            }
        }, failure: { error in // check request failed
            // FIXME: 10003 ???
            log.error(error)/
            failure?()
        })
    }
    
    static func bindTju(tjuname: String , tjupwd: String, success: (()->())?, failure: (()->())?) {
        let para = ["tjuuname": tjuname,
                    "tjupasswd": tjupwd]
        SolaSessionManager.solaSession(withType: .get, url: "/auth/bind/tju", token: TwTKeychain.shared.token, parameters: para, success: { dict in
            if let error_code = dict["error_code"] as? Int {
                if error_code == -1 {
                    UserDefaults.standard.set(true, forKey: TJU_BIND_KEY)
                    success?()
                } else {
                    if let msg = dict["message"] as? String {
                        log.word(msg)/
                    }
                }
            }
        }, failure: { error in
            log.error(error)/
            failure?()
        })
    }
    
    
}
