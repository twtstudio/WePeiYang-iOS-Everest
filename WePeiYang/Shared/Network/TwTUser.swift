//
//  TwTUser.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

// TODO: Codable
class TwTUser: Codable {
    static var shared = TwTUser()
    private init() {}
    var token: String?
    var username: String = ""
    var password: String = ""
//    var libraryState: Bool = false
    var schoolID: String = ""
    var tjuBindingState: Bool = false
    var tjuPassword: String = ""

    var libBindingState: Bool = false
    var libPassword: String = ""
    var bicycleBindingState: Bool = false
    var WLANBindingState: Bool = false
    var WLANAccount: String?
    var WLANPassword: String?
    var dropout: String = "-1"
    var avatarURL: String?
    var twtid: String?
    var realname: String?
    
    func save() {
//        CacheManager.store(object: self, in: .group, as: "user.json")
        Storage.store(self, in: .group, as: "user.json")
    }

    func load(success: (()->())?, failure: (()->())?) {
        guard Storage.fileExists("user.json", in: .group) else {
            failure?()
            return
        }

        let user = Storage.retreive("user.json", from: .group, as: TwTUser.self)
        if let user = user {
            TwTUser.shared = user
        }
        success?()
//        CacheManager.retreive("user.json", from: .group, as: TwTUser.self, success: { user in
//            TwTUser.shared = user
//            success?()
//        }, failure: {
//            failure?()
//        })
    }

    func delete() {
        CacheManager.clear(directory: .group)
        Storage.remove("user.json", from: .group)
        TwTUser.shared = TwTUser()
    }
}

