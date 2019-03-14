//
//  NewECardModel.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2019/3/13.
//  Copyright © 2019年 twtstudio. All rights reserved.
//

import Foundation

// MARK: API
struct NewECardAPI {
    
    static let root = "/ecard"
    
    static let profile = "/profile"
    
    static let total = "/total"
    
    static let pieChart = "/pieChart"
    
    static let turnover = "/turnover"
    
    static let QA = "/QA"
    
    static let dynamic = "/dynamic"
    
}

// MARK: - Network
struct ECardHelper {
    
    static func getProfile(success: @escaping (ECardProfileModel)->(), failure: @escaping (Error)->()) {
        guard let username = TWTKeychain.username(for: .ecard),
            let password = TWTKeychain.password(for: .ecard) else {
                failure(WPYCustomError.custom("请先绑定校园卡"))
                return
        }
        
        SolaSessionManager.solaSession(url: NewECardAPI.root + NewECardAPI.profile, parameters: ["password": password, "cardnum": username], success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let eCardProfile = try? ECardProfileModel(data: data) {
                success(eCardProfile)
            } else {
                log("WARNING -- ECardHelper.getProfile")
                failure(WPYCustomError.custom("校园卡解析失败"))
                return
            }
        }) { error in
            failure(error)
            print("ERROR -- ECardHelper.getProfile")
        }
    }
    
    static func getTotal(success: @escaping (ECardTotalModel)->(), failure: @escaping (Error)->()) {
        guard let username = TWTKeychain.username(for: .ecard),
            let password = TWTKeychain.password(for: .ecard) else {
                failure(WPYCustomError.custom("请先绑定校园卡"))
                return
        }
        
        SolaSessionManager.solaSession(url: NewECardAPI.root + NewECardAPI.total, parameters: ["password": password, "cardnum": username], success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let eCardTotal = try? ECardTotalModel(data: data) {
                success(eCardTotal)
            } else {
                log("WARNING -- ECardHelper.getTotal")
                failure(WPYCustomError.custom("校园卡解析失败"))
                return
            }
        }) { error in
            failure(error)
            print("ERROR -- ECardHelper.getTotal")
        }
    }
    
    static func getPieChart(term: String, success: @escaping (ECardPieChartModel)->(), failure: @escaping (Error)->()) {
        guard let username = TWTKeychain.username(for: .ecard),
            let password = TWTKeychain.password(for: .ecard) else {
                failure(WPYCustomError.custom("请先绑定校园卡"))
                return
        }
        
        SolaSessionManager.solaSession(url: NewECardAPI.root + NewECardAPI.pieChart, parameters: ["password": password, "cardnum": username, "term": term], success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let eCardPieChart = try? ECardPieChartModel(data: data) {
                success(eCardPieChart)
            } else {
                log("WARNING -- ECardHelper.getPieChart")
                failure(WPYCustomError.custom("校园卡解析失败"))
                return
            }
        }) { error in
            failure(error)
            print("ERROR -- ECardHelper.getPieChart")
        }
    }
    
    static func getTurnover(term: String, success: @escaping (ECardTurnoverModel)->(), failure: @escaping (Error)->()) {
        guard let username = TWTKeychain.username(for: .ecard),
            let password = TWTKeychain.password(for: .ecard) else {
                failure(WPYCustomError.custom("请先绑定校园卡"))
                return
        }
        
        SolaSessionManager.solaSession(url: NewECardAPI.root + NewECardAPI.turnover, parameters: ["password": password, "cardnum": username, "term": term], success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let eCardTurnover = try? ECardTurnoverModel(data: data) {
                success(eCardTurnover)
            } else {
                log("WARNING -- ECardHelper.getTurnover")
                failure(WPYCustomError.custom("校园卡解析失败"))
                return
            }
        }) { error in
            failure(error)
            print("ERROR -- ECardHelper.getTurnover")
        }
    }
    
    static func getDynamic(success: @escaping (ECardDynamicModel)->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(url: NewECardAPI.root + NewECardAPI.dynamic, success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let eCardDynamic = try? ECardDynamicModel(data: data) {
                success(eCardDynamic)
            } else {
                log("WARNING -- ECardHelper.getProfile")
                failure(WPYCustomError.custom("校园卡解析失败"))
                return
            }
        }) { error in
            failure(error)
            print("ERROR -- ECardHelper.getProfile")
        }
    }
    
}

// MARK: - Model (Profile)
struct ECardProfileModel: Codable {
    let errorCode: Int
    let message: String
    let data: ECardProfileData
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct ECardProfileData: Codable {
    let name, cardnum, cardstatus, balance: String
    let expiry, subsidy, amount: String
}

extension ECardProfileModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ECardProfileModel.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        errorCode: Int? = nil,
        message: String? = nil,
        data: ECardProfileData? = nil
        ) -> ECardProfileModel {
        return ECardProfileModel(
            errorCode: errorCode ?? self.errorCode,
            message: message ?? self.message,
            data: data ?? self.data
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension ECardProfileData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ECardProfileData.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        name: String? = nil,
        cardnum: String? = nil,
        cardstatus: String? = nil,
        balance: String? = nil,
        expiry: String? = nil,
        subsidy: String? = nil,
        amount: String? = nil
        ) -> ECardProfileData {
        return ECardProfileData(
            name: name ?? self.name,
            cardnum: cardnum ?? self.cardnum,
            cardstatus: cardstatus ?? self.cardstatus,
            balance: balance ?? self.balance,
            expiry: expiry ?? self.expiry,
            subsidy: subsidy ?? self.subsidy,
            amount: amount ?? self.amount
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Model (Total)
struct ECardTotalModel: Codable {
    let errorCode: Int
    let message: String
    let data: ECardTotalData
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct ECardTotalData: Codable {
    let totalDay: Int
    let totalMonth: Double
    
    enum CodingKeys: String, CodingKey {
        case totalDay = "total_day"
        case totalMonth = "total_month"
    }
}

extension ECardTotalModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ECardTotalModel.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        errorCode: Int? = nil,
        message: String? = nil,
        data: ECardTotalData? = nil
        ) -> ECardTotalModel {
        return ECardTotalModel(
            errorCode: errorCode ?? self.errorCode,
            message: message ?? self.message,
            data: data ?? self.data
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension ECardTotalData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ECardTotalData.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        totalDay: Int? = nil,
        totalMonth: Double? = nil
        ) -> ECardTotalData {
        return ECardTotalData(
            totalDay: totalDay ?? self.totalDay,
            totalMonth: totalMonth ?? self.totalMonth
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Model (PieChart)
struct ECardPieChartModel: Codable {
    let errorCode: Int
    let message: String
    let data: [ECardPieChartData]
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct ECardPieChartData: Codable {
    let type: String
    let total: Double
}

extension ECardPieChartModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ECardPieChartModel.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        errorCode: Int? = nil,
        message: String? = nil,
        data: [ECardPieChartData]? = nil
        ) -> ECardPieChartModel {
        return ECardPieChartModel(
            errorCode: errorCode ?? self.errorCode,
            message: message ?? self.message,
            data: data ?? self.data
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension ECardPieChartData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ECardPieChartData.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        type: String? = nil,
        total: Double? = nil
        ) -> ECardPieChartData {
        return ECardPieChartData(
            type: type ?? self.type,
            total: total ?? self.total
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Model (Turnover)
struct ECardTurnoverModel: Codable {
    let errorCode: Int
    let message: String
    let data: ECardTurnoverData
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct ECardTurnoverData: Codable {
    let recharge, consumption: [ECardDetail]
}

struct ECardDetail: Codable {
    let date, time, location, amount: String
    let balance: String
}

extension ECardTurnoverModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ECardTurnoverModel.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        errorCode: Int? = nil,
        message: String? = nil,
        data: ECardTurnoverData? = nil
        ) -> ECardTurnoverModel {
        return ECardTurnoverModel(
            errorCode: errorCode ?? self.errorCode,
            message: message ?? self.message,
            data: data ?? self.data
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension ECardTurnoverData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ECardTurnoverData.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        recharge: [ECardDetail]? = nil,
        consumption: [ECardDetail]? = nil
        ) -> ECardTurnoverData {
        return ECardTurnoverData(
            recharge: recharge ?? self.recharge,
            consumption: consumption ?? self.consumption
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension ECardDetail {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ECardDetail.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        date: String? = nil,
        time: String? = nil,
        location: String? = nil,
        amount: String? = nil,
        balance: String? = nil
        ) -> ECardDetail {
        return ECardDetail(
            date: date ?? self.date,
            time: time ?? self.time,
            location: location ?? self.location,
            amount: amount ?? self.amount,
            balance: balance ?? self.balance
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Model (Dynamic)
typealias ECardDynamicModel = [ECardDynamicData]

struct ECardDynamicData: Codable {
    let id: Int
    let date, title, content: String
}

extension ECardDynamicData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ECardDynamicData.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: Int? = nil,
        date: String? = nil,
        title: String? = nil,
        content: String? = nil
        ) -> ECardDynamicData {
        return ECardDynamicData(
            id: id ?? self.id,
            date: date ?? self.date,
            title: title ?? self.title,
            content: content ?? self.content
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == ECardDynamicModel.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ECardDynamicModel.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
