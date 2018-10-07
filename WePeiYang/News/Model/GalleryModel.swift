//
//  GalleryModel.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/2.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

//struct GalleryModel: Codable {
//    let id: Int
//    let title, description, author, coverURL: String
//    let viewCount: Int
//    let coverThumbnailURL, dateTime: String
//
//    enum CodingKeys: String, CodingKey {
//        case id, title, description, author
//        case coverURL = "coverUrl"
//        case viewCount = "view_count"
//        case coverThumbnailURL = "coverThumbnailUrl"
//        case dateTime
//    }
//}
//
//// MARK: Convenience initializers
//
//extension GalleryModel {
//    init(data: Data) throws {
//        self = try JSONDecoder().decode(GalleryModel.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func jsonData() throws -> Data {
//        return try JSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//typealias Galleries = [GalleryModel]
//extension Array where Element == Galleries.Element {
//    init(data: Data) throws {
//        self = try JSONDecoder().decode(Galleries.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func jsonData() throws -> Data {
//        return try JSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}

typealias Galleries = [GalleryModel]

struct GalleryModel: Codable {
    let id: Int
    let title, description, author, coverURL: String
    let viewCount, coverThumbnailURL, dateTime: String

    enum CodingKeys: String, CodingKey {
        case id, title, description, author
        case coverURL = "coverUrl"
        case viewCount = "view_count"
        case coverThumbnailURL = "coverThumbnailUrl"
        case dateTime
    }
}

// MARK: Convenience initializers

extension GalleryModel {
    init(data: Data) throws {
        self = try JSONDecoder().decode(GalleryModel.self, from: data)
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

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == Galleries.Element {
    init(data: Data) throws {
        self = try JSONDecoder().decode(Galleries.self, from: data)
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

    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
