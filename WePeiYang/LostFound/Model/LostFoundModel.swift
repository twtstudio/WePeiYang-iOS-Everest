//
//  LostFoundModel.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

// MARK: - Model
struct LostModel: Codable {
    let errorCode: Int
    let message: String
    let data: [LostData]
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct LostData: Codable {
    let id, type: Int
    let name, title, place, time: String
    let phone: String
    let detailType, isback: Int
    let picture: [String]?
    let publishEnd: String
    let campus: Int
    
    enum CodingKeys: String, CodingKey {
        case id, type, name, title, place, time, phone
        case detailType = "detail_type"
        case isback, picture
        case publishEnd = "publish_end"
        case campus
    }
}

// MARK: - Initialization
extension LostModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LostModel.self, from: data)
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
        data: [LostData]? = nil
        ) -> LostModel {
        return LostModel(
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

extension LostData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LostData.self, from: data)
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
        type: Int? = nil,
        name: String? = nil,
        title: String? = nil,
        place: String? = nil,
        time: String? = nil,
        phone: String? = nil,
        detailType: Int? = nil,
        isback: Int? = nil,
        picture: [String]?? = nil,
        publishEnd: String? = nil,
        campus: Int? = nil
        ) -> LostData {
        return LostData(
            id: id ?? self.id,
            type: type ?? self.type,
            name: name ?? self.name,
            title: title ?? self.title,
            place: place ?? self.place,
            time: time ?? self.time,
            phone: phone ?? self.phone,
            detailType: detailType ?? self.detailType,
            isback: isback ?? self.isback,
            picture: picture ?? self.picture,
            publishEnd: publishEnd ?? self.publishEnd,
            campus: campus ?? self.campus
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Model
struct FoundModel: Codable {
    let errorCode: Int
    let message: String
    let data: [FoundData]
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct FoundData: Codable {
    let id, type: Int
    let name, title, place, time: String
    let phone: String
    let detailType, isback: Int
    let picture: [String]?
    let recapturePlace: String
    let recaptureEntrance: Int
    let publishEnd: String
    let campus: Int
    
    enum CodingKeys: String, CodingKey {
        case id, type, name, title, place, time, phone
        case detailType = "detail_type"
        case isback, picture
        case recapturePlace = "recapture_place"
        case recaptureEntrance = "recapture_entrance"
        case publishEnd = "publish_end"
        case campus
    }
}

// MARK: - Initialization
extension FoundModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FoundModel.self, from: data)
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
        data: [FoundData]? = nil
        ) -> FoundModel {
        return FoundModel(
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

extension FoundData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(FoundData.self, from: data)
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
        type: Int? = nil,
        name: String? = nil,
        title: String? = nil,
        place: String? = nil,
        time: String? = nil,
        phone: String? = nil,
        detailType: Int? = nil,
        isback: Int? = nil,
        picture: [String]?? = nil,
        recapturePlace: String? = nil,
        recaptureEntrance: Int? = nil,
        publishEnd: String? = nil,
        campus: Int? = nil
        ) -> FoundData {
        return FoundData(
            id: id ?? self.id,
            type: type ?? self.type,
            name: name ?? self.name,
            title: title ?? self.title,
            place: place ?? self.place,
            time: time ?? self.time,
            phone: phone ?? self.phone,
            detailType: detailType ?? self.detailType,
            isback: isback ?? self.isback,
            picture: picture ?? self.picture,
            recapturePlace: recapturePlace ?? self.recapturePlace,
            recaptureEntrance: recaptureEntrance ?? self.recaptureEntrance,
            publishEnd: publishEnd ?? self.publishEnd,
            campus: campus ?? self.campus
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Origin
class LostFoundModel {
    
    var id = 0
    var detailType = 0
    var time = ""
    var picture = ""
    var place = ""
    var title = ""
    var phone = ""
    var isback = ""
    var name = ""
    
    init(id: Int, title: String, detailType: Int, time: String, picture: String, place: String, phone: String, isback: String, name: String) {
        self.id = id
        self.title = title
        self.detailType = detailType
        self.time = time
        self.picture = picture
        self.place = place
        self.phone = phone
        self.isback = isback
        self.name = name
    }
}
