//
//  CacheManager.swift
//  WePeiYang
//
//  Created by Halcao on 2017/3/11.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

let suiteName = "group.WePeiYang"

struct CacheManager {

    static func saveCache(cacheData data: Any, key keyStr: String) {
        let cachePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending(keyStr)
        let fileManager = FileManager()
        if fileManager.fileExists(atPath: cachePath) {
            log("Cache file: \(keyStr) exists and replaced.")
            try! fileManager.removeItem(atPath: cachePath)
        }
        fileManager.createFile(atPath: cachePath, contents: nil, attributes: nil)
        let toSaveCache = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: toSaveCache)
        archiver.encode(data, forKey: "data")
        let now = Date()
        archiver.encode(now, forKey: "time")
        archiver.finishEncoding()
        toSaveCache.write(toFile: cachePath, atomically: true)
    }

    static func loadCache(withKey keyStr: String, success: ((Any) -> Void)?, failure: (() -> Void)?) {
        let cachePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending(keyStr)
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: cachePath) {
            failure?()
            log("Cache file \(keyStr) doesn't Exist!")
            return
        } else {
            let url = URL(fileURLWithPath: cachePath)
            let data = try! Data(contentsOf: url)
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            let cacheObject = unarchiver.decodeObject(forKey: "data")
            unarchiver.finishDecoding()
            if let cacheObject = cacheObject {
                success?(cacheObject)
                log("Cache data \(keyStr) loaded in block.")
            } else {
                log( "Cache data \(keyStr) can't load in block.")
            }
        }
    }

    static func removeCache(withKey keyStr: String) {
        let cachePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending(keyStr)
        let fileManager = FileManager()
        if fileManager.fileExists(atPath: cachePath) {
            try! fileManager.removeItem(atPath: cachePath)
            log("Cache data \(keyStr) removed in block.")
        } else {
            log("Cache file \(keyStr) doesn't Exist!")
        }
    }

    static func cacheExists(withKey keyStr: String) -> Bool {
        let cachePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending(keyStr)
        return FileManager().fileExists(atPath: cachePath)
    }

    static func saveGroupCache(with data: Any, key keyStr: String) {
        let userDefault = UserDefaults(suiteName: suiteName)
        removeGroupCache(withKey: keyStr)
        userDefault?.set(data, forKey: keyStr)
        userDefault?.synchronize()
    }

    static func removeGroupCache(withKey keyStr: String) {
        let userDefault = UserDefaults(suiteName: suiteName)
        userDefault?.removeObject(forKey: keyStr)
        userDefault?.synchronize()
    }

    static func loadGroupCache(withKey keyStr: String) -> Any? {
        let userDefault = UserDefaults(suiteName: suiteName)
        let cacheData = userDefault?.object(forKey: keyStr)
        return cacheData
    }

    static func loadGroupCacheAsync(withKey keyStr: String, success: @escaping (Any?) -> Void) {
        let queue = DispatchQueue(label: "load_default")
        queue.async {
            let userDefault = UserDefaults(suiteName: suiteName)
            let cacheData = userDefault?.object(forKey: keyStr)
            success(cacheData)
        }
    }

//    static func loadGroupCache(withKey keyStr: String, success: ((Any)->())?) {
//        let userDefault = UserDefaults(suiteName: suiteName)
//        let cacheData = userDefault?.object(forKey: keyStr)
//        if let cacheData = cacheData {
//            success?(cacheData)
//        } else {
//            log.errorMessage("Group Cache file \(keyStr) can't load")/
//        }
//    }

    static func groupCacheExists(withKey keyStr: String) -> Bool {
        let userDefault = UserDefaults(suiteName: suiteName)
        let cacheData = userDefault?.object(forKey: keyStr)
        if cacheData != nil {
            return true
        }
        return false
    }

    static func store<T: Encodable>(object: T, in directory: Storage.Directory, as filename: String) {
        let newName = newFilename(in: directory, filename: filename)
        Storage.store(["com.wpy.cache": object], in: directory, as: newName)
    }

    static func retreive<T: Decodable>(_ filename: String, from directory: Storage.Directory, as type: T.Type, success: @escaping (T) -> Void, failure: (() -> Void)? = nil) {
        guard fileExists(filename: filename, in: directory) else {
            failure?()
            return
        }

        let queue = DispatchQueue(label: "com.wpy.cache")
        queue.async {
            let newName = newFilename(in: directory, filename: filename)
            let obj = Storage.retreive(newName, from: directory, as: [String: T].self)
            DispatchQueue.main.async {
                if let obj = obj, let object = obj["com.wpy.cache"] {
                    success(object)
                } else {
                    failure?()
                }
            }
        }
    }

    static func fileExists(filename: String, in directory: Storage.Directory) -> Bool {
        let newName = newFilename(in: directory, filename: filename)
        return Storage.fileExists(newName, in: directory)
    }

    static func clear(directory: Storage.Directory) {
        if let username = TwTUser.shared.username {
            Storage.clear(subdirectory: username, in: directory)
        }
    }

    static func delete(filename: String, in directory: Storage.Directory) {
        guard fileExists(filename: filename, in: directory) else {
            return
        }
        let newName = newFilename(in: directory, filename: filename)
        Storage.remove(newName, from: directory)
    }

    static private func newFilename(in directory: Storage.Directory, filename: String) -> String {
        let username = TwTUser.shared.username ?? ""
        let newFilename = directory != .caches ? username + "/" + filename : filename
        return newFilename
    }

    // user relevant data is stored in `schoolID` subdirectory before
    // and now it should be in `username` subdirectory
    static func migrate() {
        guard let schoolID = TwTUser.shared.schoolID,
            let username = TwTUser.shared.username else {
                return
        }
        if Storage.fileExists(schoolID, in: .documents) {
            Storage.move(source: schoolID, destination: username, in: .documents)
        }
        if Storage.fileExists(schoolID, in: .group) {
            Storage.move(source: schoolID, destination: username, in: .group)
        }
    }
}
