//
//  AccountManager.swift
//  WePeiYang
//
//  Created by Halcao on 2017/3/23.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation

struct AccountManager {

    static func getToken(username: String, password: String, success: ((String) -> Void)?, failure: ((String) -> Void)?) {
        let para: [String: String] = ["twtuname": username, "twtpasswd": password]
        SolaSessionManager.solaSession(type: .get, url: "/auth/token/get", token: nil, parameters: para, success: { dic in
            if let data = dic["data"] as? [String: Any],
                let token = data["token"] as? String {
                success?(token)
            } else {
                failure?(dic["message"] as? String ?? "解析失败 请稍候重试")
            }
        }, failure: { error in
            failure?(error.localizedDescription)
        })

    }

    static func refreshToken(success: (() -> Void)? = nil, failure: (() -> Void)?) {
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
            TwTUser.shared.delete()
        }) // refresh finished
    }

    static func checkToken(success: (() -> Void)? = nil, failure: (() -> Void)?) {
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

    static func bindTju(tjuname: String, tjupwd: String, success: (() -> Void)?, failure: (() -> Void)?) {
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

    static func unbindTju(tjuname: String, tjupwd: String, success: (() -> Void)?, failure: (() -> Void)?) {
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

    static func getSelf(success: (() -> Void)?, failure: (() -> Void)?) {
        SolaSessionManager.solaSession(type: .get, baseURL: "https://open.twtstudio.com", url: "/api/v2/auth/self", parameters: nil, success: { dict in
            if let errorno = dict["error_code"] as? Int,
                let message = dict["message"] as? String,
            message == "token expired" || errorno == 10003 || errorno == 10000 {
                guard TwTUser.shared.username != "", TwTUser.shared.password != "" else {
                    SwiftMessages.showWarningMessage(body: "登录过期，请重新登录")
                    showLoginView()
                    return
                }

                AccountManager.getToken(username: TwTUser.shared.username, password: TwTUser.shared.password, success: { token in
                    TwTUser.shared.token = token
                    TwTUser.shared.save()
                }, failure: { _ in

                })
            }

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
                TwTUser.shared.save()
                success?()
            }
        }, failure: { _ in
            // FIXME: 错误
            failure?()
        })
    }

}
