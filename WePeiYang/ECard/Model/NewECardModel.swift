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
    
}

// MARK: - Model
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
