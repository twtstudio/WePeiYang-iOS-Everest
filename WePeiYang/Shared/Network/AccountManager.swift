
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
//    static func removeToken() {
//        UserDefaults.standard.removeObject(forKey: TOKEN_SAVE_KEY)
//        UserDefaults.standard.removeObject(forKey: ID_SAVE_KEY)
//        UserDefaults.standard.removeObject(forKey: "readToken")
//
//        CacheManager.removeCache(withKey: GPA_CACHE)
//        CacheManager.removeGroupCache(withKey: CLASSTABLE_TERM_START_KEY)
//        CacheManager.removeGroupCache(withKey: CLASSTABLE_CACHE_KEY)
//        CacheManager.removeGroupCache(withKey: CLASSTABLE_COLOR_CONFIG_KEY)
//        // TODO: CSSearchable
//    }
    
    static func getToken(username: String, password: String, success: ((String)->())?, failure: ((Error?)->())?) {
        let para: Dictionary<String, String> = ["twtuname": username, "twtpasswd": password]
        SolaSessionManager.solaSession(type: .get, url: "/auth/token/get", token: nil, parameters: para, success: { dic in
            if let data = dic["data"] as? Dictionary<String, AnyObject> {
                if let token = data["token"] as? String {
                    success?(token)
                }
            }
            
        }, failure: { error in
            failure?(error)
        })
        
    }
    
     // FIXME: every time open the app, refresh token
    static func refreshToken(success: (()->())? = nil, failure: (()->())?) {
        SolaSessionManager.solaSession(type: .get, url: "/auth/token/refresh", parameters: nil, success: { dict in
            if let newToken = dict["data"] as? String {
                TwTUser.shared.token = newToken
                TwTUser.shared.save()
                //啥都不用做
                success?()
                return
            }
            if let msg = dict["message"] as? String {
                log.word(msg)/
            }
        }, failure: { error in
            log.error(error)/
            failure?()
            // FIXME 获取失败我也不知道怎么做 难道要重新登录
            TwTUser.shared.delete()
        }) // refresh finished
    }
    
    static func checkToken(success: (()->())? = nil, failure: (()->())?) {
        SolaSessionManager.solaSession(type: .get, url: "/auth/token/check", parameters: nil, success: { dict in
            if let error_code = dict["error_code"] as? Int {
                if error_code == -1 {
                    //啥都不用做
                    success?()
                } else if error_code == 10003 { // 过期
                    // refresh token
                    SolaSessionManager.solaSession(type: .get, url: "/auth/token/refresh", parameters: nil, success: { dict in
                        if let newToken = dict["data"] as? String {
                            TwTUser.shared.token = newToken
                            TwTUser.shared.save()
                            //啥都不用做
                            success?()
                            return
                        }
                        if let msg = dict["message"] as? String {
                            log.word(msg)/
                        }
                    }, failure: { error in
                        log.error(error)/
                        failure?()
                        // FIXME 获取失败我也不知道怎么做 难道要重新登录
                        TwTUser.shared.delete()
                    }) // refresh finished

                } else if let msg = dict["message"] as? String { // check failed
                    failure?()
                    log.errorMessage(msg)/
//                    self.removeToken()
                } else {
                    failure?()
//                    self.removeToken()
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
        SolaSessionManager.solaSession(type: .get, url: "/auth/bind/tju", parameters: para, success: { dict in
            if let error_code = dict["error_code"] as? Int {
                if error_code == -1 {
                    TwTUser.shared.tjuBindingState = true
                    TwTUser.shared.save()
//                    UserDefaults.standard.set(true, forKey: TJU_BIND_KEY)
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
    
    static func unbindTju(tjuname: String , tjupwd: String, success: (()->())?, failure: (()->())?) {
        SolaSessionManager.solaSession(type: .get, url: "/auth/unbind/tju", parameters: nil, success: { dict in
            if let error_code = dict["error_code"] as? Int {
                if error_code == -1 {
                    TwTUser.shared.tjuBindingState = false
                    TwTUser.shared.save()
//                    UserDefaults.standard.set(false, forKey: TJU_BIND_KEY)
//                    CacheManager.removeCache(withKey: GPA_CACHE)
//                    CacheManager.removeCache(withKey: GPA_USER_NAME_CACHE)
//                    CacheManager.removeGroupCache(withKey: CLASSTABLE_COLOR_CONFIG_KEY)
//                    CacheManager.removeGroupCache(withKey: CLASSTABLE_CACHE_KEY)
//                    CacheManager.removeGroupCache(withKey: CLASSTABLE_TERM_START_KEY)
                    // TODO: Spotlight
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
    
    static func getSelf(success: (()->())?, failure: (()->())?) {
        SolaSessionManager.solaSession(type: .get, baseURL: "", url: TwTAPI.`self`, parameters: nil, success: { dict in
            if let accounts = dict["accounts"] as? [String: Any],
                let tju = accounts["tju"] as? Bool,
                let lib = accounts["lib"] as? Bool,
                let avatar = dict["avatar"] as? String,
                let realname = dict["realname"] as? String,
                let twtid = dict["twtid"] as? String,
                let studentid = dict["studentid"] as? String,
                let dropout = dict["dropout"] as? String {
                TwTUser.shared.avatarURL = avatar
                TwTUser.shared.tjuBindingState = tju
                TwTUser.shared.libBindingState = lib
                TwTUser.shared.realname = realname
                TwTUser.shared.twtid = twtid
                TwTUser.shared.schoolID = studentid
                TwTUser.shared.dropout = dropout
            }
        }, failure: { error in
            print(error)
        })
    }

}
