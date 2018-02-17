//
//  Storage.swift
//  WePeiYang
//
//  Created by Halcao on 2018/2/15.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

struct Storage {
    fileprivate init() { }
    enum Directory {
        // Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory and will be automatically backed up by iCloud.
        case documents

        // Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
        case caches

        // Data that can be shared with other app
        case group
    }

    // returns file url by directory
    private  static func getURL(for diretory: Directory) -> URL {
        var searchDirectory: FileManager.SearchPathDirectory
        switch diretory {
        case .caches:
            searchDirectory = .cachesDirectory
        case .documents:
            searchDirectory = .documentDirectory
        case .group:
            return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.WePeiyang")!
        }
        if let url = FileManager.default.urls(for: searchDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
    }

    /// store object in directory as filename on disk
    ///
    /// - Parameters:
    ///   - object: the encodable object to store
    ///   - directory: where to store
    ///   - filename: the name of file
    static func store<T: Encodable>(_ object: T, in directory: Directory, as filename: String) {
        let url = getURL(for: directory).appendingPathComponent(filename, isDirectory: false)
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            // FIXME: handle error
            fatalError(error.localizedDescription)
        }
    }

    /// retrieve object from disk
    ///
    /// - Parameters:
    ///   - filename: the name of file
    ///   - directory: where to retrieve
    ///   - type: object type
    /// - Returns: decoded struct model(s) of data
    static func retreive<T: Decodable>(_ filename: String, from directory: Directory, as type: T.Type) -> T {
        let url = getURL(for: directory).appendingPathComponent(filename, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("error: \(filename) does not exist")
        }

        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                // FIXME: handle error
                fatalError("error decode data")
            }
        } else {
            // FIXME: handle error
            fatalError("error decode data")
        }
    }

    /// remove specified file from specified directory
    /// returns remove result
    @discardableResult static func remove(_ filename: String, from directory: Directory) -> Bool {
        let url = getURL(for: directory).appendingPathComponent(filename, isDirectory: false)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            return false
        }
        return true
    }

    /// clear all files in directory
    static func clear(_ directory: Directory) {
        let url = getURL(for: directory)
        do {

            let urls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for file in urls {
                try FileManager.default.removeItem(at: file)
            }
        } catch {
            // FIXME: handle error
            fatalError("error decode data")
        }
    }
}
