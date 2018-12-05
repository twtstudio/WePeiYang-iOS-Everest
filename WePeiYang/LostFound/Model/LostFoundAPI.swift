//
//  LostFoundAPI.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

// MARK: API
struct LostFoundAPI {
    
    static let root = "https://open-lostfound.twtstudio.com/api/v1/lostfound"
    
    static let lost = "/lost"
    
}

// MARK: - Network
struct LostFoundHelper {
    static func getLost(timeblock: Int = 5, campus: Int = 1, page: Int = 1, detailType: Int = 0, success: @escaping (LostModel) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.solaSession(baseURL: LostFoundAPI.root, url: LostFoundAPI.lost, parameters: ["timeblock": String(timeblock), "campus": String(campus), "page": String(page), "detail_type": String(detailType)], success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)), let lost = try? LostModel(data: data) {
                success(lost)
            } else { log("WARNING -- LostModel.getLost") }
        }) { error in
            failure(error)
            log("ERROR -- LostModel.getLost")
        }
    }
}

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

// MARK: - Origin
class GetLostAPI {
    
    static func getLost(page: Int, success: @escaping ([LostFoundModel]) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.solaSession(baseURL: "https://open-lostfound.twtstudio.com/api/v1", url: "/lostfound/lost?page=\(page)", success: {
            dic in
            
            if let lostData = dic["data"] as? [[String: Any]] {
                var losts = [LostFoundModel]()
                for lost in lostData {
                    let detailType = lost["detail_type"] as? Int ?? 0
                    let time = lost["time"] as? String ?? ""
                    let title = lost["title"] as? String ?? ""
                    let picture = lost["picture"] as? String ?? ""
                    let place = lost["place"] as? String ?? ""
                    let id = lost["id"] as? Int ?? 0
                    let isback = lost["isback"] as? String ?? ""
                    let name = lost["name"] as? String ?? ""
                    let phone = lost["phone"] as? String ?? ""
                    
                    let lostModel = LostFoundModel(id: id, title: title, detailType: detailType, time: time, picture: picture, place: place, phone: phone, isback: isback, name: name)
                    losts.append(lostModel)
                    
                }
                success(losts)
            }
            
        }, failure: { err in
            // TODO: error
            failure(err)
        })
    }
}

class GetFoundAPI {
    
    static func getFound(page: Int, success: @escaping ([LostFoundModel]) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.solaSession(baseURL: "https://open-lostfound.twtstudio.com/api/v1", url: "/lostfound/found?page=\(page)", success: { dic in
            if let foundData = dic["data"] as? [[String: Any]] {
                var founds = [LostFoundModel]()
                for found in foundData {
                    
                    let detailType = found["detail_type"] as? Int ?? 0
                    let time = found["time"] as? String ?? ""
                    let title = found["title"] as? String ?? ""
                    let picture = found["picture"] as? String ?? ""
                    let place = found["place"] as? String ?? ""
                    let id = found["id"] as? Int ?? 0
                    let isback = found["isback"] as? String ?? ""
                    let name = found["name"] as? String ?? ""
                    let phone = found["phone"] as? String ?? ""
                    
                    let foundModel = LostFoundModel(id: id, title: title, detailType: detailType, time: time, picture: picture, place: place, phone: phone, isback: isback, name: name)
                    founds.append(foundModel)
                    
                }
                success(founds)
            }
            
        }, failure: { err in
            // TODO: error
            failure(err)
        })
    }
    
}

class GetMyLostAPI {
    
    static func getMyLost(page: Int, success: @escaping ([MyLostFoundModel]) -> Void, failure: @escaping (Error) -> Void) {
        
        SolaSessionManager.solaSession(baseURL: "https://open-lostfound.twtstudio.com/api/v1", url: "/lostfound/user/lost?page=\(page)", success: { dic in
            if let myLostData = dic["data"] as? [[String: Any]] {
                var myLosts = [MyLostFoundModel]()
                for lost in myLostData {
                    
                    let detailType = lost["detail_type"] as? Int ?? 0
                    let time = lost["time"] as? String ?? ""
                    let title = lost["title"] as? String ?? ""
                    let picture = lost["picture"] as? String ?? ""
                    let place = lost["place"] as? String ?? ""
                    let id = lost["id"] as? Int ?? 0
                    let isback = lost["isback"] as? String ?? ""
                    let name = lost["name"] as? String ?? ""
                    let phone = lost["phone"] as? String ?? ""
                    
                    let myLostModel = MyLostFoundModel(isBack: isback, title: title, detailType: detailType, time: time, place: place, picture: picture, id: id, name: name, phone: phone)
                    myLosts.append(myLostModel)
                }
                success(myLosts)
            }
            
        }, failure: { err in
            // TODO: error
            failure(err)
        })
    }
}

class GetMyFoundAPI {
    
    static func getMyFound(page: Int, success: @escaping ([MyLostFoundModel]) -> Void, failure: @escaping (Error) -> Void) {
        
        SolaSessionManager.solaSession(baseURL: "https://open-lostfound.twtstudio.com/api/v1", url: "/lostfound/user/found?page=\(page)", success: { dic in
            if let myFoundData = dic["data"] as? [[String: Any]] {
                var myFounds = [MyLostFoundModel]()
                for found in myFoundData {
                    
                    let detailType = found["detail_type"] as? Int ?? 0
                    let time = found["time"] as? String ?? ""
                    let title = found["title"] as? String ?? ""
                    let picture = found["picture"] as? String ?? ""
                    let place = found["place"] as? String ?? ""
                    let id = found["id"] as? Int ?? 0
                    let isback = found["isback"] as? String ?? ""
                    let name = found["name"] as? String ?? ""
                    let phone = found["phone"] as? String ?? ""
                    
                    let myFoundModel = MyLostFoundModel(isBack: isback, title: title, detailType: detailType, time: time, place: place, picture: picture, id: id, name: name, phone: phone)
                    myFounds.append(myFoundModel)
                }
                success(myFounds)
            }
            
        }, failure: { err in
            // TODO: error
            failure(err)
        })
    }
}

class DetailAPI {
    
    //    var id = 0
    var detailDisplay: [Any] = []
    
    func getDetail(id: String, success: @escaping ([LostFoundDetailModel]) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.solaSession(baseURL: "https://open-lostfound.twtstudio.com/api/v1", url: ("/lostfound/"+"\(id)"), success: { dic in
            if let detailData = dic["data"] as? [String: Any] {
                
                var details = [LostFoundDetailModel]()
                //                for (key, value) in detailData {
                
                let detailType = detailData["detail_type"] as? Int ?? 0
                let time = detailData["time"] as? String ?? ""
                let title = detailData["title"] as? String ?? ""
                let picture =  detailData["picture"] as? String ?? ""
                let place = detailData["place"] as? String ?? ""
                let id = detailData["id"] as? Int ?? 0
                let name = detailData["name"] as? String ?? ""
                let phone = detailData["phone"] as? String ?? ""
                let item_description = detailData["item_description"] as? String ?? ""
                let card_name = detailData["card_name"] as? String ?? ""
                let card_number = detailData["card_number"] as? Int ?? 0
                let publish_start = detailData["publish_start"] as? String ?? ""
                let publish_end = detailData["publish_end"] as? String ?? ""
                let other_tag = detailData["other_tag"] as? String ?? ""
                let type = detailData["type"] as? Int ?? 0
                
                let lostFoundDetailModel = LostFoundDetailModel(id: id, name: name, title: title, place: place, phone: phone, time: time, picture: picture, item_description: item_description, card_name: card_name, card_number: card_number, publish_start: publish_start, publish_end: publish_end, other_tag: other_tag, type: type, detailType: detailType)
                self.detailDisplay = [time, place, detailType, name, phone, item_description ]
                details.append(lostFoundDetailModel)
                //                }
                success(details)
            }
            
        }, failure: { err in
            // TODO: error
            failure(err)
        })
    }
}

class GetSearchAPI {
    
    static func getSearch(inputText: String, page: Int, success: @escaping ([LostFoundModel]) -> Void, failure: @escaping (Error) -> Void) {
        
        let utf8Text = "/lostfound/search?keyword=\(inputText)&page=\(page)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        SolaSessionManager.solaSession(type: .get, baseURL: "https://open-lostfound.twtstudio.com/api/v1", url: utf8Text, success: { dic in
            if let searchData = dic["data"] as? [[String: Any]] {
                
                var searchs = [LostFoundModel]()
                for search in searchData {
                    
                    let detailType = search["detail_type"] as? Int ?? 0
                    let time = search["time"] as? String ?? ""
                    let title = search["title"] as? String ?? ""
                    let picture = search["picture"] as? String ?? ""
                    let place = search["place"] as? String ?? ""
                    let id = search["id"] as? Int ?? 0
                    let isback = search["isback"] as? String ?? ""
                    let name = search["name"] as? String ?? ""
                    let phone = search["phone"] as? String ?? ""
                    
                    let searchModel = LostFoundModel(id: id, title: title, detailType: detailType, time: time, picture: picture, place: place, phone: phone, isback: isback, name: name)
                    searchs.append(searchModel)
                }
                success(searchs)
            }
            //            }
        }, failure: { err in
            // TODO: error
            failure(err)
        })
    }
    
}

class PostLostAPI {

    static func postLost(markDic: [String: Any], tag: String, success: @escaping ([String: Any]) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.upload(dictionay: markDic, url: "/lostfound/"+tag, method: .post, progressBlock: nil, failure: { err in
            // TODO: error
            failure(err)
        }, success: success)
    }
}

class GetInverseAPI {
    
    static func getInverse(id: String, success: @escaping (Int) -> Void, failure: @escaping (Error) -> Void) {
        SolaSessionManager.solaSession(type: .get, baseURL: "https://open-lostfound.twtstudio.com/api/v1", url: "/lostfound/inverse/" + "\(id)", success: { dic in
            if let error_code = dic["error_code"] as? Int {
                success(error_code)
            }
        }, failure: { err in
            // TODO: error
            failure(err)
        })
    }
}
