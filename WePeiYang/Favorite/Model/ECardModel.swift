//
//  ECardModel.swift
//  WePeiYang
//
//  Created by Halcao on 2018/11/27.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

enum TransactionType: Int {
    case topup = 1
    case expense = 2
}

struct EcardProfile: Codable {
    let cardnum, cardstatus, balance, expiry: String
    let amount: String
    let subsidy: String
}

struct EcardTransaction: Codable {
    let transaction: [Transaction]
}

struct Transaction: Codable {
    enum CodingKeys: String, CodingKey {
        case date
        case location
        case amount
        case balance
        case time
    }
    let date, time, location, amount: String
    let balance: String
    var type = 2
}

struct ECardAPI {

    static func getProfile(success: @escaping (EcardProfile) -> Void, failure: @escaping (Error) -> Void) {
        guard let username = TWTKeychain.username(for: .ecard),
            let password = TWTKeychain.password(for: .ecard) else {
                failure(WPYCustomError.custom("请先绑定校园卡"))
                return
        }

        SolaSessionManager.solaSession(type: .get, url: "/ecard/profile", parameters: ["password": password, "cardnum": username], success: { dict in
            guard let content = dict["data"] as? [String: Any],
                let data = try? JSONSerialization.data(withJSONObject: content, options: .init(rawValue: 0)),
                let response = try? EcardProfile(data: data) else {
                    failure(WPYCustomError.custom("校园卡解析失败"))
                    return
            }
            success(response)

        }, failure: failure)
    }

    static func getTransaction(page: Int = 1, callback: @escaping ([Transaction], Error?) -> Void) {
        var error: Error?
        guard let username = TWTKeychain.username(for: .ecard),
            let password = TWTKeychain.password(for: .ecard) else {
                error = WPYCustomError.custom("请先绑定校园卡")
                callback([], error)
                return
        }
        let day = page * 7

        var result: [Transaction] = []
        let group = DispatchGroup()
        group.enter()
        SolaSessionManager.solaSession(type: .get, url: "/ecard/transaction", parameters: ["password": password, "cardnum": username, "day": "\(day)", "type": "\(TransactionType.topup.rawValue)"], success: { dict in
            defer {
                group.leave()
            }

            if let data = dict["data"] as? [String: String],
                let errmsg = data["info"] {
                error = WPYCustomError.custom(errmsg)
                return
            }

            guard let content = dict["data"] as? [String: Any],
                let data = try? JSONSerialization.data(withJSONObject: content, options: .init(rawValue: 0)),
                let topup = try? EcardTransaction(data: data) else {
                    error = WPYCustomError.custom("流水解析失败")
                    return
            }

            let list = topup.transaction.map { item -> Transaction in
                var item = item
                item.type = TransactionType.topup.rawValue
                return item
            }
            result.append(contentsOf: list)
        }, failure: { err in
            group.leave()
            error = err
        })

        group.enter()
        SolaSessionManager.solaSession(type: .get, url: "/ecard/transaction", parameters: ["password": password, "cardnum": username, "day": "\(day)", "type": "\(TransactionType.expense.rawValue)"], success: { dict in
            defer {
                group.leave()
            }
            
            if let data = dict["data"] as? [String: String],
                let errmsg = data["info"] {
                error = WPYCustomError.custom(errmsg)
                return
            }

            guard let content = dict["data"] as? [String: Any],
                let data = try? JSONSerialization.data(withJSONObject: content, options: .init(rawValue: 0)),
                let expense = try? EcardTransaction(data: data) else {
                    error = WPYCustomError.custom("流水解析失败")
                    return
            }

            let list = expense.transaction.map { item -> Transaction in
                var item = item
                item.type = TransactionType.expense.rawValue
                return item
            }
            result.append(contentsOf: list)
        }, failure: { err in
            error = err
            group.leave()
        })

        group.notify(queue: .main, execute: {
            result.sort(by: { a, b in
                let aval = a.date + a.time
                let bval = b.date + b.time
                return aval > bval
            })

            callback(result, error)
        })
    }
}
