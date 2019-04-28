//
//  JobFire.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/4/27.
//  Copyright © 2019 twtstudio. All rights reserved.
//



import Foundation

struct JobFireUrl {
    static var url: String = ""
}

struct JobFireHelper {
    static func getJobFire(success: @escaping (JobFire)->(), failure: @escaping (Error)->()) {
        Helper.dataManager(url: "\(JobFireUrl.url)", success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let jobFire = try? JobFire(data: data) {
                success(jobFire)
            }else {
                print("if fail")
            }
        }, failure: { _ in
            
        })
    }
}

struct JobFire: Codable {
    let errorCode: Int?
    let message: String?
    let data: JobFireDataClass?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct JobFireDataClass: Codable {
    let type: String?
    let pageCount: Int?
    let page: String?
    let important, common: [JobFireCommon]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case pageCount = "page_count"
        case page, important, common
    }
}

struct JobFireCommon: Codable {
    let id, title, heldDate, heldTime: String?
    let place, date, click, important: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case heldDate = "held_date"
        case heldTime = "held_time"
        case place, date, click, important
    }
}

// MARK: Convenience initializers and mutators

extension JobFire {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(JobFire.self, from: data)
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
        data: JobFireDataClass?? = nil
        ) -> JobFire {
        return JobFire(
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

extension JobFireDataClass {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(JobFireDataClass.self, from: data)
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
        page: String?? = nil,
        important: [JobFireCommon]?? = nil,
        common: [JobFireCommon]?? = nil
        ) -> JobFireDataClass {
        return JobFireDataClass(
            type: type ?? self.type,
            pageCount: pageCount ?? self.pageCount,
            page: page ?? self.page,
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

extension JobFireCommon {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(JobFireCommon.self, from: data)
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
        click: String?? = nil,
        important: String?? = nil
        ) -> JobFireCommon {
        return JobFireCommon(
            id: id ?? self.id,
            title: title ?? self.title,
            heldDate: heldDate ?? self.heldDate,
            heldTime: heldTime ?? self.heldTime,
            place: place ?? self.place,
            date: date ?? self.date,
            click: click ?? self.click,
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


