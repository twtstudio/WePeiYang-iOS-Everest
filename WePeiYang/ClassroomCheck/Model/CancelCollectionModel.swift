//
//  CancelCollectionModel.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation

// MARK: - CancelCollectionData
struct CancelCollectionData: Codable {
    let errorCode: Int
    let message: String
    let data: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

// MARK: CancelCollectionData convenience initializers and mutators

extension CancelCollectionData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CancelCollectionData.self, from: data)
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
        data: [JSONAny]? = nil
    ) -> CancelCollectionData {
        return CancelCollectionData(
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

