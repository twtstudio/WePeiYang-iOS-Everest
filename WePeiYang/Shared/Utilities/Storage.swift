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
            // FIXME: 这里竟然会错
            return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.WePeiYang") ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        if let url = FileManager.default.urls(for: searchDirectory, in: .userDomainMask).first {
            return url
        } else {
            // 不该错吧...
            fatalError("Could not create URL for specified directory!")
        }
    }

    /// store object in directory as filename on disk
    ///
    /// - Parameters:
    ///   - object: the encodable object to store
    ///   - directory: where to store
    ///   - filename: the name of file
    static func store<T: Encodable>(_ object: T, in directory: Directory, as filename: String, success: (() -> Void)? = nil, failure: (() -> Void)? = nil) {
        var url = getURL(for: directory)
        var dirs = filename.split(separator: "/")

        let encoder = JSONEncoder()
        do {
            for i in 0..<dirs.count {
                if i == dirs.count - 1 {
                    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                    url.appendPathComponent(String(dirs[i]), isDirectory: false)
                } else {
                    url.appendPathComponent(String(dirs[i]), isDirectory: true)
                }
            }

            let data = try encoder.encode(object)
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }

            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            // FIXME: handle error
            // 我觉得不该错
//            fatalError(error.localizedDescription)
        }
    }

    /// retrieve object from disk
    ///
    /// - Parameters:
    ///   - filename: the name of file
    ///   - directory: where to retrieve
    ///   - type: object type
    /// - Returns: decoded struct model(s) of data
    static func retreive<T: Decodable>(_ filename: String, from directory: Directory, as type: T.Type) -> T? {
        let url = getURL(for: directory).appendingPathComponent(filename, isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path) {
            return nil
        }

        if let data = FileManager.default.contents(atPath: url.path) {
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(type, from: data)
                return model
            } catch {
                return nil
            }
        } else {
            return nil
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
    static func clear(subdirectory: String = "", in directory: Directory) {
        let url = getURL(for: directory).appendingPathComponent(subdirectory, isDirectory: true)
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for file in urls {
                try FileManager.default.removeItem(at: file)
            }
        } catch {
            // FIXME: handle error
//            fatalError("error decode data")
        }
    }

    @discardableResult
    static func move(source: String, destination: String, in directory: Directory) -> Bool {
        let sourceURL = getURL(for: directory).appendingPathComponent(source)
        let destinationURL = getURL(for: directory).appendingPathComponent(destination)
        do {
            try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
        } catch {
            log(error)
            return false
        }
        return true
    }

    /// Returns BOOL indicating whether file exists at specified directory with specified file name
    static func fileExists(_ filename: String, in directory: Directory) -> Bool {
        let url = getURL(for: directory).appendingPathComponent(filename, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
}
