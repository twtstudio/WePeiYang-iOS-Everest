//
//  WLANHelper.swift
//  WePeiYang
//
//  Created by Tigris on 3/8/18.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct WLANHelper {
    static var isOnline = false

    static func login(username: String? = nil, password: String? = nil, success: @escaping ()->(), failure: @escaping (String)->()) {
        guard let account = username ?? TwTUser.shared.WLANAccount,
            let password = password ?? TwTUser.shared.WLANPassword else {
                failure("请绑定账号")
                return
        }

        let campus = UserDefaults.standard.bool(forKey: "newCampus") ? "0" : "1"
        let loginInfo = ["username": account, "password": password, "campus": campus]

        SolaSessionManager.solaSession(type: .get, url: WLANLoginAPIs.loginURL, parameters: loginInfo, success: { dict in
            guard let errorCode = dict["error_code"] as? Int,
                let errMsg = dict["message"] as? String else {
                    failure("解析错误")
                    return
            }
            if errorCode == -1 {
                WLANHelper.isOnline = true
                success()
            } else if errorCode == 50002 {
                failure("密码错误")
            } else {
                failure(errMsg)
            }
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }

    static func logout(username: String? = nil, password: String? = nil, success: @escaping ()->(), failure: @escaping (String)->()) {
        guard let account = username ?? TwTUser.shared.WLANAccount,
            let password = password ?? TwTUser.shared.WLANPassword else {
                failure("请绑定账号")
                return
        }

        let campus = UserDefaults.standard.bool(forKey: "newCampus") ? "0" : "1"
        let loginInfo = ["username": account, "password": password, "campus": campus]

        SolaSessionManager.solaSession(type: .get, url: WLANLoginAPIs.logoutURL, parameters: loginInfo, success: { dict in
            guard let errorCode = dict["error_code"] as? Int,
                let errMsg = dict["message"] as? String else {
                    failure("解析错误")
                    return
            }

            if errorCode == -1 {
                WLANHelper.isOnline = false
                success()
            } else {
                failure(errMsg)
            }
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }

    static func getStatus(username: String? = nil, password: String? = nil, success: @escaping (Bool)->(), failure: @escaping (String)->()) {
        guard let account = username ?? TwTUser.shared.WLANAccount,
            let password = password ?? TwTUser.shared.WLANPassword else {
                failure("请绑定账号")
                return
        }

        let loginInfo = ["username": account, "password": password]
        SolaSessionManager.solaSession(type: .get, url: WLANLoginAPIs.getStatus, token: nil, parameters: loginInfo, success: { dict in
            if let data = dict["data"] as? [String: Any],
                let isOnline = data["online"] as? Int {
                let result = isOnline == 0 ? false : true
                WLANHelper.isOnline = result
                success(result)
                return
            }
            failure("解析失败")
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }
}
