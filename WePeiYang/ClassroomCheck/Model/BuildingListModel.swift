//
//  BuildingListModel.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import Foundation

// MARK: - BuildingList
struct BuildingList: Codable {
    let errorCode: Int
    let message: String
    let data: [Building]

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, data
    }
}

extension BuildingList {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(BuildingList.self, from: data)
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
        data: [Building]? = nil
    ) -> BuildingList {
        return BuildingList(
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

// MARK: - Datum
struct Building: Codable {
    let buildingID, building, campusID: String
    let areaID: JSONNull?
    let classrooms: [Classroom]

    enum CodingKeys: String, CodingKey {
        case buildingID = "building_id"
        case building
        case campusID = "campus_id"
        case areaID = "area_id"
        case classrooms
    }
}

extension Building {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Building.self, from: data)
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
        buildingID: String? = nil,
        building: String? = nil,
        campusID: String? = nil,
        areaID: JSONNull?? = nil,
        classrooms: [Classroom]? = nil
    ) -> Building {
        return Building(
            buildingID: buildingID ?? self.buildingID,
            building: building ?? self.building,
            campusID: campusID ?? self.campusID,
            areaID: areaID ?? self.areaID,
            classrooms: classrooms ?? self.classrooms
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Classroom
struct Classroom: Codable {
    let classroomID, classroom, capacity: String

    enum CodingKeys: String, CodingKey {
        case classroomID = "classroom_id"
        case classroom, capacity
//        case buildingID = "building_id"
    }
}

extension Classroom {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Classroom.self, from: data)
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
        classroomID: String? = nil,
        classroom: String? = nil,
        capacity: String? = nil
    ) -> Classroom {
        return Classroom(
            classroomID: classroomID ?? self.classroomID,
            classroom: classroom ?? self.classroom,
            capacity: capacity ?? self.capacity
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

