//
//  SearchInfo.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/4/27.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import Foundation

struct SearchUrl {
    static var url: String = ""
}

struct SearchResultHelper {
    static func getSearchResult(success: @escaping (SearchAnnouncement)->(), failure: @escaping (Error)->()) {
        Helper.dataManager(url: "\(SearchUrl.url)", success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let searchResult = try? SearchAnnouncement(data: data) {
                success(searchResult)
            }else {
                print("if fail")
            }
        }, failure: { _ in
            
        })
    }
}

struct SearchAnnouncement: Codable {
    let errorCode: Int?
    let message: String?
    let data: SearchDataClass?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct SearchDataClass: Codable {
    let info, meeting: [Info]?
}

struct Info: Codable {
    let id, title: String?
    let heldDate, heldTime, place: String?
    let date, click: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case heldDate = "held_date"
        case heldTime = "held_time"
        case place, date, click
    }
}

// MARK: Convenience initializers and mutators

extension SearchAnnouncement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SearchAnnouncement.self, from: data)
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
        data: SearchDataClass?? = nil
        ) -> SearchAnnouncement {
        return SearchAnnouncement(
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

extension SearchDataClass {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SearchDataClass.self, from: data)
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
        info: [Info]?? = nil,
        meeting: [Info]?? = nil
        ) -> SearchDataClass {
        return SearchDataClass(
            info: info ?? self.info,
            meeting: meeting ?? self.meeting
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Info {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Info.self, from: data)
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
        id: String?? = nil,
        title: String?? = nil,
        heldDate: String?? = nil,
        heldTime: String?? = nil,
        place: String?? = nil,
        date: String?? = nil,
        click: String?? = nil
        ) -> Info {
        return Info(
            id: id ?? self.id,
            title: title ?? self.title,
            heldDate: heldDate ?? self.heldDate,
            heldTime: heldTime ?? self.heldTime,
            place: place ?? self.place,
            date: date ?? self.date,
            click: click ?? self.click
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
