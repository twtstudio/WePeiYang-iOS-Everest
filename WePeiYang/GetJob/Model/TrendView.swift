//
//  TrendView.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/4/28.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import Foundation

struct TrendHelper {
    static func getTrend(success: @escaping (TrendsView)->(), failure: @escaping (Error)->()) {
        Helper.dataManager(url: "\(Page.url)", success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let trends = try? TrendsView(data: data) {
                success(trends)
            }else {
                print("if fail")
            }
        }, failure: { _ in
            
        })
    }
}

struct TrendsView: Codable {
    let errorCode: Int?
    let message: String?
    let data: TrendDataClass?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct TrendDataClass: Codable {
    let type: String?
    let pageCount: Int?
    let currentPage: String?
    let rotation: [TrendRotation]?
    let important, common: [TrendCommon]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case pageCount = "page_count"
        case currentPage = "current_page"
        case rotation, important, common
    }
}

struct TrendCommon: Codable {
    let id: Int?
    let title, click, date, important: String?
}

struct TrendRotation: Codable {
    let id: Int?
    let title, click, date: String?
    let important: Int?
}

// MARK: Convenience initializers and mutators

extension TrendsView {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TrendsView.self, from: data)
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
        errorCode: Int?? = nil,
        message: String?? = nil,
        data: TrendDataClass?? = nil
        ) -> TrendsView {
        return TrendsView(
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

extension TrendDataClass {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TrendDataClass.self, from: data)
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
        type: String?? = nil,
        pageCount: Int?? = nil,
        currentPage: String?? = nil,
        rotation: [TrendRotation]?? = nil,
        important: [TrendCommon]?? = nil,
        common: [TrendCommon]?? = nil
        ) -> TrendDataClass {
        return TrendDataClass(
            type: type ?? self.type,
            pageCount: pageCount ?? self.pageCount,
            currentPage: currentPage ?? self.currentPage,
            rotation: rotation ?? self.rotation,
            important: important ?? self.important,
            common: common ?? self.common
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension TrendCommon {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TrendCommon.self, from: data)
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
        id: Int?? = nil,
        title: String?? = nil,
        click: String?? = nil,
        date: String?? = nil,
        important: String?? = nil
        ) -> TrendCommon {
        return TrendCommon(
            id: id ?? self.id,
            title: title ?? self.title,
            click: click ?? self.click,
            date: date ?? self.date,
            important: important ?? self.important
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension TrendRotation {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TrendRotation.self, from: data)
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
        id: Int?? = nil,
        title: String?? = nil,
        click: String?? = nil,
        date: String?? = nil,
        important: Int?? = nil
        ) -> TrendRotation {
        return TrendRotation(
            id: id ?? self.id,
            title: title ?? self.title,
            click: click ?? self.click,
            date: date ?? self.date,
            important: important ?? self.important
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

