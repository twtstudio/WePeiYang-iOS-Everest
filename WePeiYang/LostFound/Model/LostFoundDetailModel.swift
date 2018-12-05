//
//  LostFoundDetailModel.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

// MARK: - Model
struct LFDetailModel: Codable {
    let errorCode: Int?
    let message: String?
    let data: LFDetailData?
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

struct LFDetailData: Codable {
    let id, campus, type: Int?
    let title, name, time, place: String?
    let phone, itemDescription: String?
    let detailType: Int?
    let picture: [String]?
    let cardName, cardNumber, publishStart, publishEnd: String?
    let otherTag, recapturePlace: String?
    let recaptureEntrance: Int?
    let qq, wechat: String?
    
    enum CodingKeys: String, CodingKey {
        case id, campus, type, title, name, time, place, phone
        case itemDescription = "item_description"
        case detailType = "detail_type"
        case picture
        case cardName = "card_name"
        case cardNumber = "card_number"
        case publishStart = "publish_start"
        case publishEnd = "publish_end"
        case otherTag = "other_tag"
        case recapturePlace = "recapture_place"
        case recaptureEntrance = "recapture_entrance"
        case qq, wechat
    }
}

// MARK: - Initialization
extension LFDetailModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LFDetailModel.self, from: data)
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
        data: LFDetailData?? = nil
        ) -> LFDetailModel {
        return LFDetailModel(
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

extension LFDetailData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(LFDetailData.self, from: data)
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
        campus: Int?? = nil,
        type: Int?? = nil,
        title: String?? = nil,
        name: String?? = nil,
        time: String?? = nil,
        place: String?? = nil,
        phone: String?? = nil,
        itemDescription: String?? = nil,
        detailType: Int?? = nil,
        picture: [String]?? = nil,
        cardName: String?? = nil,
        cardNumber: String?? = nil,
        publishStart: String?? = nil,
        publishEnd: String?? = nil,
        otherTag: String?? = nil,
        recapturePlace: String?? = nil,
        recaptureEntrance: Int?? = nil,
        qq: String?? = nil,
        wechat: String?? = nil
        ) -> LFDetailData {
        return LFDetailData(
            id: id ?? self.id,
            campus: campus ?? self.campus,
            type: type ?? self.type,
            title: title ?? self.title,
            name: name ?? self.name,
            time: time ?? self.time,
            place: place ?? self.place,
            phone: phone ?? self.phone,
            itemDescription: itemDescription ?? self.itemDescription,
            detailType: detailType ?? self.detailType,
            picture: picture ?? self.picture,
            cardName: cardName ?? self.cardName,
            cardNumber: cardNumber ?? self.cardNumber,
            publishStart: publishStart ?? self.publishStart,
            publishEnd: publishEnd ?? self.publishEnd,
            otherTag: otherTag ?? self.otherTag,
            recapturePlace: recapturePlace ?? self.recapturePlace,
            recaptureEntrance: recaptureEntrance ?? self.recaptureEntrance,
            qq: qq ?? self.qq,
            wechat: wechat ?? self.wechat
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
class LostFoundDetailModel {

    var id = 0
    var name = ""
    var title = ""
    var place = ""
    var phone = ""
    var time = ""
    var picture = ""
    var item_description = "" //介绍
    var detailType = 0
    var card_name = ""
    var card_number = 0
    var publish_start = ""
    var publish_end = ""
    var other_tag = ""
    var type = 0

    init(id: Int, name: String, title: String, place: String, phone: String, time: String, picture: String, item_description: String, card_name: String, card_number: Int, publish_start: String, publish_end: String, other_tag: String, type: Int, detailType: Int) {
        self.id = id
        self.name = name
        self.title = title
        self.place = place
        self.phone = phone
        self.time = time
        self.picture = picture
        self.item_description = item_description
        self.card_name = card_name
        self.card_number = card_number
        self.publish_start = publish_start
        self.publish_end = publish_end
        self.other_tag = other_tag
        self.type = type
    }

}
