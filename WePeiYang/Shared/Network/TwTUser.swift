//
//  TwTUser.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

// TODO: Codable
class TwTUser: NSObject, Codable {
    static var shared = TwTUser()
    private override init() {}
    var token: String?
    var username: String = ""
    var libraryState: Bool = false
    var schoolID: String = ""
    var tjuBindingState: Bool = false
    var libBindingState: Bool = false
    var bicycleBindingState: Bool = false
    var WLANBindingState: Bool = false
    var WLANAccount: String?
    var WLANPassword: String?
    var dropout: String = "-1"
    var avatarURL: String?
    var twtid: String?
    var realname: String?
    
//    func save() {
//        var dic: [String: Any] = [:]
//        var outCount: UInt32 = 0
//        let ivars = class_copyIvarList(TwTUser.self, &outCount)
//        for i in 0..<outCount {
//            if let ivar = ivars?[Int(i)],
//                let cName = ivar_getName(ivar),
//                let name = String(cString: cName, encoding: String.Encoding.utf8), let obj = self.value(forKey: name) {
//                // save non-nil property
//                dic[name] = obj
//            }
//        }
//        let dict = NSDictionary(dictionary: dic)
//        CacheManager.saveGroupCache(with: dict, key: "TwTUser")
////        UserDefaults(suiteName: suiteName)?.set(dict, forKey: "TwTUser")
//    }

//    func delete() {
//        CacheManager.removeGroupCache(withKey: "TwTUser")
////        UserDefaults(suiteName: suiteName)?.removeObject(forKey: "TwTUser")
//        self.token = nil
//        self.avatarURL = ""
//        self.bicycleBindingState = false
//        self.realname = ""
//        self.username = ""
//        self.schoolID = ""
//        CacheManager.clear(directory: .group)
//    }

//    func load(success: (()->())?, failure: (()->())?) {
//        // load from
//        if let dict = CacheManager.loadGroupCache(withKey: "TwTUser") as? NSDictionary {
//            var outCount: UInt32 = 0
//            let ivars = class_copyIvarList(TwTUser.self, &outCount)
//            for i in 0..<outCount {
//                if let ivar = ivars?[Int(i)],
//                    let cName = ivar_getName(ivar),
//                    let name = String(cString: cName, encoding: String.Encoding.utf8), let value = dict[name] {
//                    // save non-nil property
//                    self.setValue(value, forKey: name)
//                }
//            }
//            success?()
//        } else {
//            failure?()
//        }
//    }
    func save() {
        CacheManager.store(object: self, in: .group, as: "user.json")
    }

    func load(success: (()->())?, failure: (()->())?) {
        CacheManager.retreive("user.json", from: .group, as: TwTUser.self, success: { user in
            TwTUser.shared = user
            success?()
        }, failure: {
            failure?()
        })
    }

    func delete() {
        CacheManager.clear(directory: .group)
        TwTUser.shared = TwTUser()
    }
}

