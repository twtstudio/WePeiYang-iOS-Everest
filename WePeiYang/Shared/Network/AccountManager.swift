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
            } else
            if let msg = dict["message"] as? String {
                SwiftMessages.showErrorMessage(body: msg)
            } else {
                SwiftMessages.showErrorMessage(body: "登录状态异常，请尝试重新登录")
            }
        }, failure: { error in
            log(error)
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
                            log(msg)
                        }
                    }, failure: { error in
                        log(error)
                        failure?()
                        // FIXME 获取失败我也不知道怎么做 难道要重新登录
                        TwTUser.shared.delete()
                    }) // refresh finished

                } else if let msg = dict["message"] as? String { // check failed
                    failure?()
                    log(msg)
//                    self.removeToken()
                } else {
                    failure?()
//                    self.removeToken()
                }
            }
        }, failure: { error in // check request failed
            // FIXME: 10003 ???
            log(error)
            failure?()
        })
    }

    static func unbind(url: String, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.solaSession(type: .get, url: url, token: TwTUser.shared.token, success: { dictionary in
            guard let errorCode: Int = dictionary["error_code"] as? Int, let message = dictionary["message"] as? String else {
                failure(WPYCustomError.custom("解析错误"))
                return
            }

            if errorCode == -1 {
                SwiftMessages.showSuccessMessage(body: "解绑成功")
                success()
            } else {
                SwiftMessages.showErrorMessage(body: message)
            }
        })

    }

    static func getSelf(success: (() -> Void)?, failure: (() -> Void)?) {
        SolaSessionManager.solaSession(type: .get, baseURL: "https://open.twt.edu.cn", url: "/api/v2/auth/self", parameters: nil, success: { dict in
            if let errorno = dict["error_code"] as? Int,
                let message = dict["message"] as? String,
            message == "token expired" || errorno == 10003 || errorno == 10000 {
                guard let username = TwTUser.shared.username,
                    let password = TWTKeychain.password(for: .root) else {
                    SwiftMessages.showWarningMessage(body: "登录过期，请重新登录")
                    showLoginView()
                    return
                }

                AccountManager.getToken(username: username, password: password, success: { token in
                    TwTUser.shared.username = username
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
                let twtid = dict["twtid"] as? Int,
                let studentid = dict["studentid"] as? String {
                TwTUser.shared.avatarURL = avatar
                TwTUser.shared.tjuBindingState = tju
                TwTUser.shared.libBindingState = lib
                TwTUser.shared.realname = realname
                TwTUser.shared.twtid = twtid.description
                TwTUser.shared.schoolID = studentid
                TwTUser.shared.save()
                success?()
            }
        }, failure: { _ in
            // FIXME: 错误
            failure?()
        })
    }

}
