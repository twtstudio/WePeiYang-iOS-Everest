//
//  LoginModel.swift
//  WePeiYang
//
//  Created by 安宇 on 24/08/2019.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import Foundation

// MARK: - SongListModel
struct LoginModel: Codable {
    let message: String
    let errorCode: Int
    let data: ActivityLogin
    
    enum CodingKeys: String, CodingKey {
        case message
        case errorCode = "error_code"
        case data
    }
}

// MARK: SongListModel convenience initializers and mutators

extension LoginModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LoginModel.self, from: data)
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
        data: ActivityLogin? = nil
        ) -> LoginModel {
        return LoginModel(
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

// MARK: - DataClass
struct ActivityLogin: Codable {
    let userID: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
    }
}

// MARK: DataClass convenience initializers and mutators

extension ActivityLogin {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ActivityLogin.self, from: data)
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
        userID: Int? = nil
        ) -> ActivityLogin {
        return ActivityLogin(
            userID: userID ?? self.userID
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
