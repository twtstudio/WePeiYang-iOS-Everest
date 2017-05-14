//
//  CacheManager.swift
//  WePeiYang
//
//  Created by Halcao on 2017/3/11.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

struct CacheManager {
    
    static func saveCache(cacheData data: Any, key keyStr: String) {
        let cachePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending(keyStr)
        let fileManager = FileManager()
        if fileManager.fileExists(atPath: cachePath) {
            log.word("Cache file: \(keyStr) exists and replaced.")/
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
    
    static func loadCache(withKey keyStr: String, success: ((Any)->())?, failure: (()->())?) {
        let cachePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending(keyStr)
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: cachePath) {
            failure?()
            log.errorMessage("Cache file \(keyStr) doesn't Exist!")/
            return
        } else {
            let url = URL(fileURLWithPath: cachePath)
            let data = try! Data(contentsOf: url)
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            let cacheObject = unarchiver.decodeObject(forKey: "data")
            unarchiver.finishDecoding()
            if let cacheObject = cacheObject {
                success?(cacheObject)
                log.word("Cache data \(keyStr) loaded in block.")/
            } else {
                log.errorMessage( "Cache data \(keyStr) can't load in block.")/
            }
        }
    }
    
    static func removeCache(withKey keyStr: String) {
        let cachePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending(keyStr)
        let fileManager = FileManager()
        if fileManager.fileExists(atPath: cachePath) {
            try! fileManager.removeItem(atPath: cachePath)
            log.word("Cache data \(keyStr) removed in block.")/
        } else {
            log.errorMessage("Cache file \(keyStr) doesn't Exist!")/
        }
    }
    
    static func cacheExists(withKey keyStr: String) -> Bool {
        let cachePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending(keyStr)
        return FileManager().fileExists(atPath: cachePath)
    }
    
    static func saveGroupCache(with data: Any, key keyStr: String) {
        let userDefault = UserDefaults(suiteName: "group.WePeiYang")
        removeGroupCache(withKey: keyStr)
        userDefault?.set(data, forKey: keyStr)
        userDefault?.synchronize()
    }
    
    static func removeGroupCache(withKey keyStr: String) {
        let userDefault = UserDefaults(suiteName: "group.WePeiYang")
        userDefault?.removeObject(forKey: keyStr)
        userDefault?.synchronize()
    }
    
    static func loadGroupCache(withKey keyStr: String, success: ((Any)->())?) {
        let userDefault = UserDefaults(suiteName: "group.WePeiYang")
        let cacheData = userDefault?.object(forKey: keyStr)
        if let cacheData = cacheData {
            success?(cacheData)
        } else {
            log.errorMessage("Group Cache file \(keyStr) can't load")/
        }
    }
    
    static func groupCacheExists(withKey keyStr: String) -> Bool {
        let userDefault = UserDefaults(suiteName: "group.WePeiYang")
        let cacheData = userDefault?.object(forKey: keyStr)
        if cacheData != nil {
            return true
        }
        return false
    }
        
}
