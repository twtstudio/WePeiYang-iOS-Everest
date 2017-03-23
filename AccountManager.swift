
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
    
    static func getToken(with username: String, password: String, success: (Void->Void)?, failure: (Error->Void)?) {
        let para: Dictionary<String, String> = ["twtuname": username, "twtpasswd": password]
        SolaSessionManager.solaSession(withType: .get, url: "/auth/token/get", token: nil, parameters: para, success: { response in
            
        }, failure: failure)
        
    }
    
}
