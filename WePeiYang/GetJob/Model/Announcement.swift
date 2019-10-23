//
//  Announcement.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/4/21.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import Foundation
struct Page {
    static var currentPage: Int = 1
    static var url: String = ""
}
struct AnnouncementHelper {
    static func getAnnouncement(success: @escaping (Announcement)->(), failure: @escaping (Error)->()) {
        Helper.dataManager(url: "\(Page.url)", success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let announcement = try? Announcement(data: data) {
                success(announcement)
            }
        }, failure: { _ in
            
        })
    }
}

struct Announcement: Codable {
    let errorCode: Int?
    let message: String?
    let data: AnnDataClass?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct AnnDataClass: Codable {
    let type: String?
    let pageCount: Int?
    let currentPage: String?
    let rotation: JSONNull?
    let important, common: [Common]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case pageCount = "page_count"
        case currentPage = "current_page"
        case rotation, important, common
    }
}

struct Common: Codable {
    let id: Int?
    let title, click, date, important: String?
}

// MARK: Convenience initializers and mutators

extension Announcement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Announcement.self, from: data)
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
        data: AnnDataClass?? = nil
        ) -> Announcement {
        return Announcement(
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

extension Common {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Common.self, from: data)
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
        ) -> Common {
        return Common(
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

