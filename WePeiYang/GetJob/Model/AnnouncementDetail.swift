//
//  AnnouncementDetail.swift
//  WePeiYang
//
//  Created by 王春杉 on 2019/4/21.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import Foundation
import Alamofire

struct didSelectCell {
    static var id: String = ""
}

struct Helper {
    static func dataManager(url: String, success: (([String: Any])->())? = nil, failure: ((Error)->())? = nil) {
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value  {
                    if let dict = data as? [String: Any] {
                        success?(dict)
                    }
                }
            case .failure(let error):
                failure?(error)
                if let data = response.result.value  {
                    if let dict = data as? [String: Any],
                        let errmsg = dict["message"] as? String {
                        print(errmsg)
                    }
                } else {
                    print(error)
                }
            }
        }
    }
}

struct AnnouncementDetailHelper {
    static func getAnnouncementDetail(success: @escaping (AnnouncementDetail)->(), failure: @escaping (Error)->()) {
        Helper.dataManager(url: "http://job.api.twtstudio.com/api/notice/detail?type=0&id=\(didSelectCell.id)", success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let announcementDetail = try? AnnouncementDetail(data: data) {
                success(announcementDetail)
            }else {
                print("if fail")
            }
        }, failure: { _ in
            
        })
    }
}

struct RecruitmentDetailHelper {
    static func getRecruitmentDetail(success: @escaping (AnnouncementDetail)->(), failure: @escaping (Error)->()) {
        Helper.dataManager(url: "http://job.api.twtstudio.com/api/recruit/detail?type=0&id=\(didSelectCell.id)", success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let recruitmentDetail = try? AnnouncementDetail(data: data) {
                success(recruitmentDetail)
            }else {
                print("if fail")
            }
        }, failure: { _ in
            
        })
    }
}

struct AnnouncementDetail: Codable {
    let errorCode: Int?
    let message: String?
    let data: DataClass?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct DataClass: Codable {
    let type, id, title, content: String?
    let date: String?
    let click: Int!
    let attach1: String?
    let attach2, attach3: String?
    let attach1Name, attach2Name: String?
    let attach3Name: String?
    
    enum CodingKeys: String, CodingKey {
        case type, id, title, content, date, click, attach1, attach2, attach3
        case attach1Name = "attach1_name"
        case attach2Name = "attach2_name"
        case attach3Name = "attach3_name"
    }
}

// MARK: Convenience initializers and mutators

extension AnnouncementDetail {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AnnouncementDetail.self, from: data)
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
        data: DataClass?? = nil
        ) -> AnnouncementDetail {
        return AnnouncementDetail(
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

extension DataClass {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DataClass.self, from: data)
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
        date: String?? = nil,
        click: Int?? = nil,
        attach1: String?? = nil,
        attach2: String?? = nil,
        attach3: String?? = nil,
        attach1Name: String?? = nil,
        attach2Name: String?? = nil,
        attach3Name: String?? = nil
        ) -> DataClass {
        return DataClass(
            type: type ?? self.type,
            id: id ?? self.id,
            title: title ?? self.title,
            content: content ?? self.content,
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

