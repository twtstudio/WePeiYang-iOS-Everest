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
//    var libraryState: Bool = false
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

