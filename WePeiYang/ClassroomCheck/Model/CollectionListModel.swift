//
//  CollectionListModel.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation

// MARK: - CollectionListData
struct CollectionListData: Codable {
    var errorCode: Int
    var message: String
    var data: [Collection]

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

// MARK: CollectionListData convenience initializers and mutators

extension CollectionListData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CollectionListData.self, from: data)
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
        data: [Collection]? = nil
    ) -> CollectionListData {
        return CollectionListData(
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

// MARK: - Datum
struct Collection: Codable {
    var classroomID, classroom: String
    var capacity: Int
    var building: String

    enum CodingKeys: String, CodingKey {
        case classroomID = "classroom_ID"
        case classroom, capacity, building
    }
}

// MARK: Datum convenience initializers and mutators

extension Collection {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Collection.self, from: data)
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
        classroomID: String? = nil,
        classroom: String? = nil,
        capacity: Int? = nil,
        building: String? = nil
    ) -> Collection {
        return Collection(
            classroomID: classroomID ?? self.classroomID,
            classroom: classroom ?? self.classroom,
            capacity: capacity ?? self.capacity,
            building: building ?? self.building
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
