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

struct EcardTransaction: Codable {
    let transaction: [Transaction]
}

struct Transaction: Codable {
    let date, time, location, amount: String
    let balance: String
}

struct ECardAPI {
    enum TransactionType: Int {
        case topup = 1
        case expense = 2
    }

    static func getProfile(success: @escaping (EcardProfile) -> Void, failure: @escaping (Error) -> Void) {
        guard let username = TWTKeychain.username(for: .ecard),
            let password = TWTKeychain.password(for: .ecard) else {
                failure(WPYCustomError.custom("请先绑定校园卡"))
                return
        }

        SolaSessionManager.solaSession(type: .get, url: "/ecard/profile", parameters: ["password": password, "cardnum": username], success: { dict in
            if let data = try? JSONSerialization.data(withJSONObject: dict["data"] as Any, options: .init(rawValue: 0)),
                let response = try? EcardProfile(data: data) {
                success(response)
            } else {
                failure(WPYCustomError.custom("校园卡解析失败"))
            }
        }, failure: failure)
    }

    static func getTransaction(page: Int = 1, type: TransactionType, success: @escaping (EcardTransaction) -> Void, failure: @escaping (Error) -> Void) {
        guard let username = TWTKeychain.username(for: .ecard),
            let password = TWTKeychain.password(for: .ecard) else {
                failure(WPYCustomError.custom("请先绑定校园卡"))
                return
        }
        let day = page * 7

        SolaSessionManager.solaSession(type: .get, url: "/ecard/transaction", parameters: ["password": password, "cardnum": username, "day": "\(day)", "type": "\(type.rawValue)"], success: { dict in
            if let errmsg = (dict["data"] as? [String: String])?["info"] {
                failure(WPYCustomError.custom(errmsg))
                return
            }
            if let data = try? JSONSerialization.data(withJSONObject: dict["data"] as Any, options: .init(rawValue: 0)),
                let response = try? EcardTransaction(data: data) {
                success(response)
            } else {
                failure(WPYCustomError.custom("流水解析失败"))
            }
        }, failure: failure)
    }
}
