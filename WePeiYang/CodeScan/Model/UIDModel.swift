//
//  UIDModel.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/5/16.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation

// MARK: - Uid
struct Uid: Codable {
    let message: String
    let errorCode: Int
    let data: UidData

    enum CodingKeys: String, CodingKey {
        case message
        case errorCode = "error_code"
        case data
    }
}

// MARK: Uid convenience initializers and mutators

extension Uid {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Uid.self, from: data)
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
        message: String? = nil,
        errorCode: Int? = nil,
        data: UidData? = nil
    ) -> Uid {
        return Uid(
            message: message ?? self.message,
            errorCode: errorCode ?? self.errorCode,
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

// MARK: - UidData
struct UidData: Codable {
    let userID: Int
    let token: [String]
    let permission: Int

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case token, permission
    }
}

// MARK: UidData convenience initializers and mutators

extension UidData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UidData.self, from: data)
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
        userID: Int? = nil,
        token: [String]? = nil,
        permission: Int? = nil
    ) -> UidData {
        return UidData(
            userID: userID ?? self.userID,
            token: token ?? self.token,
            permission: permission ?? self.permission
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
