//
//  ECardModel.swift
//  WePeiYang
//
//  Created by Halcao on 2018/11/27.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct EcardProfile: Codable {
    let cardnum, cardstatus, balance, expiry: String
    let subsidy: String
}

struct EcardTransection: Codable {
    let transection: [Transection]
}

struct Transection: Codable {
    let date, time, location, amount: String
    let balance: String
}

struct ECardAPI {
    enum TransectionType: Int {
        case topup = 1
        case expense = 2
    }

    static func getProfile(success: @escaping (EcardProfile) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.solaSession(type: .get, url: "/ecard/profile", parameters: ["password": "226426", "cardnum": "3015204064"], success: { dict in
            if let data = try? JSONSerialization.data(withJSONObject: dict["data"] as Any, options: .init(rawValue: 0)),
                let response = try? EcardProfile(data: data) {
                success(response)
            } else {
                failure(WPYCustomError.custom("校园卡解析失败"))
            }
        }, failure: failure)
    }

    static func getTransection(page: Int = 1, type: TransectionType, success: @escaping (EcardTransection) -> Void, failure: @escaping (Error) -> Void) {
        let day = page * 7

        SolaSessionManager.solaSession(type: .get, url: "/ecard/transection", parameters: ["password": "226426", "cardnum": "3015204064", "day": "\(day)", "type": "\(type.rawValue)"], success: { dict in
            if let errmsg = (dict["data"] as? [String: String])?["info"] {
                failure(WPYCustomError.custom(errmsg))
                return
            }
            if let data = try? JSONSerialization.data(withJSONObject: dict["data"] as Any, options: .init(rawValue: 0)),
                let response = try? EcardTransection(data: data) {
                success(response)
            } else {
                failure(WPYCustomError.custom("流水解析失败"))
            }
        }, failure: failure)
    }
}
