//
//  GetQrCode.swift
//  WePeiYang
//
//  Created by 安宇 on 24/08/2019.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import Foundation

// MARK: - SongListModel
struct GetQrCodeModel: Codable {
    let message: String
    let errorCode: Int
    let data: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case errorCode = "error_code"
        case data
    }
}

// MARK: SongListModel convenience initializers and mutators

extension GetQrCodeModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GetQrCodeModel.self, from: data)
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
        data: String? = nil
        ) -> GetQrCodeModel {
        return GetQrCodeModel(
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
