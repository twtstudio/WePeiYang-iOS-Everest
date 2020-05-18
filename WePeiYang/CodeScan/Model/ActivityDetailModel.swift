//
//  ActivityDetailModel.swift
//  WePeiYang
//
//  Created by 安宇 on 24/08/2019.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import Foundation

// MARK: - ActivityDeatilModel
struct ActivityDeatilModel: Codable {
    let message: String
    let errorCode: Int
    let data: ActivityDeatil

    enum CodingKeys: String, CodingKey {
        case message
        case errorCode = "error_code"
        case data
    }
}

// MARK: ActivityDeatilModel convenience initializers and mutators

extension ActivityDeatilModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ActivityDeatilModel.self, from: data)
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
        message: String? = nil,
        errorCode: Int? = nil,
        data: ActivityDeatil? = nil
    ) -> ActivityDeatilModel {
        return ActivityDeatilModel(
            message: message ?? self.message,
            errorCode: errorCode ?? self.errorCode,
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

// MARK: - DataClass
struct ActivityDeatil: Codable {
    let data: [Info]
    let currentPage, lastPage, number: Int
}

// MARK: DataClass convenience initializers and mutators

extension ActivityDeatil {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ActivityDeatil.self, from: data)
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
        data: [Info]? = nil,
        currentPage: Int? = nil,
        lastPage: Int? = nil,
        number: Int? = nil
    ) -> ActivityDeatil {
        return ActivityDeatil(
            data: data ?? self.data,
            currentPage: currentPage ?? self.currentPage,
            lastPage: lastPage ?? self.lastPage,
            number: number ?? self.number
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
struct Info: Codable {
    let activityID: Int
    let title: String
    let content: String?
    let start, end: Int
    let position: String?
    let teacher: String
    let manager: [Manager]
    let numberOfManager: Int
    let worker: [Manager]
    let numberOfWorker, isStarter: Int
    let file: File

    enum CodingKeys: String, CodingKey {
        case activityID = "activity_id"
        case title, content, start, end, position, teacher, manager, numberOfManager, worker, numberOfWorker, isStarter, file
    }
}

// MARK: Datum convenience initializers and mutators

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
        activityID: Int? = nil,
        title: String? = nil,
        content: String?? = nil,
        start: Int? = nil,
        end: Int? = nil,
        position: String?? = nil,
        teacher: String? = nil,
        manager: [Manager]? = nil,
        numberOfManager: Int? = nil,
        worker: [Manager]? = nil,
        numberOfWorker: Int? = nil,
        isStarter: Int? = nil,
        file: File? = nil
    ) -> Info {
        return Info(
            activityID: activityID ?? self.activityID,
            title: title ?? self.title,
            content: content ?? self.content,
            start: start ?? self.start,
            end: end ?? self.end,
            position: position ?? self.position,
            teacher: teacher ?? self.teacher,
            manager: manager ?? self.manager,
            numberOfManager: numberOfManager ?? self.numberOfManager,
            worker: worker ?? self.worker,
            numberOfWorker: numberOfWorker ?? self.numberOfWorker,
            isStarter: isStarter ?? self.isStarter,
            file: file ?? self.file
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - File
struct File: Codable {
    let fileID: Int?
    let url, fileName: String?

    enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
        case url
        case fileName = "file_name"
    }
}

// MARK: File convenience initializers and mutators

extension File {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(File.self, from: data)
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
        fileID: Int?? = nil,
        url: String?? = nil,
        fileName: String?? = nil
    ) -> File {
        return File(
            fileID: fileID ?? self.fileID,
            url: url ?? self.url,
            fileName: fileName ?? self.fileName
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Manager
struct Manager: Codable {
    let name, studentNumber: String

    enum CodingKeys: String, CodingKey {
        case name
        case studentNumber = "student_number"
    }
}

// MARK: Manager convenience initializers and mutators

extension Manager {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Manager.self, from: data)
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
        name: String? = nil,
        studentNumber: String? = nil
    ) -> Manager {
        return Manager(
            name: name ?? self.name,
            studentNumber: studentNumber ?? self.studentNumber
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
