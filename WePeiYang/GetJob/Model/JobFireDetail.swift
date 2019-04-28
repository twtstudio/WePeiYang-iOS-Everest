//
//  JobFireDetail.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/4/27.
//  Copyright © 2019 twtstudio. All rights reserved.
//


import Foundation

struct JobFireDetailUrl {
    static var url: String = ""
}

struct JobFireDetailHelper {
    static func getJobFireDetail(success: @escaping (JobFireDetail)->(), failure: @escaping (Error)->()) {
        Helper.dataManager(url: "\(JobFireDetailUrl.url)", success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let jobFireDetail = try? JobFireDetail(data: data) {
                success(jobFireDetail)
            }else {
                print("if fail")
            }
        }, failure: { _ in
            
        })
    }
}


struct JobFireDetail: Codable {
    let errorCode: Int?
    let message: String?
    let data: JobFireDetailDataClass?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct JobFireDetailDataClass: Codable {
    let type, id, title, content: String?
    let request, corporation, heldDate, heldTime: String?
    let place, deadline, date: String?
    let click: Int?
    let attach1: String?
    let attach2, attach3, attach1Name, attach2Name: String?
    let attach3Name: String?
    
    enum CodingKeys: String, CodingKey {
        case type, id, title, content, request, corporation
        case heldDate = "held_date"
        case heldTime = "held_time"
        case place, deadline, date, click, attach1, attach2, attach3
        case attach1Name = "attach1_name"
        case attach2Name = "attach2_name"
        case attach3Name = "attach3_name"
    }
}

// MARK: Convenience initializers and mutators

extension JobFireDetail {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(JobFireDetail.self, from: data)
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
        data: JobFireDetailDataClass?? = nil
        ) -> JobFireDetail {
        return JobFireDetail(
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

extension JobFireDetailDataClass {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(JobFireDetailDataClass.self, from: data)
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
        id: String?? = nil,
        title: String?? = nil,
        content: String?? = nil,
        request: String?? = nil,
        corporation: String?? = nil,
        heldDate: String?? = nil,
        heldTime: String?? = nil,
        place: String?? = nil,
        deadline: String?? = nil,
        date: String?? = nil,
        click: Int?? = nil,
        attach1: String?? = nil,
        attach2: String?? = nil,
        attach3: String?? = nil,
        attach1Name: String?? = nil,
        attach2Name: String?? = nil,
        attach3Name: String?? = nil
        ) -> JobFireDetailDataClass {
        return JobFireDetailDataClass(
            type: type ?? self.type,
            id: id ?? self.id,
            title: title ?? self.title,
            content: content ?? self.content,
            request: request ?? self.request,
            corporation: corporation ?? self.corporation,
            heldDate: heldDate ?? self.heldDate,
            heldTime: heldTime ?? self.heldTime,
            place: place ?? self.place,
            deadline: deadline ?? self.deadline,
            date: date ?? self.date,
            click: click ?? self.click,
            attach1: attach1 ?? self.attach1,
            attach2: attach2 ?? self.attach2,
            attach3: attach3 ?? self.attach3,
            attach1Name: attach1Name ?? self.attach1Name,
            attach2Name: attach2Name ?? self.attach2Name,
            attach3Name: attach3Name ?? self.attach3Name
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

