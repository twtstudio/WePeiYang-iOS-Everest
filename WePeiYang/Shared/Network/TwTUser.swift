//
//  TwTUser.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class TwTUser: Codable {
    static let shared = TwTUser()
    private init() {}
    var token: String?
    var username: String {
        return TWTKeychain.username(for: .root) ?? ""
    }
    var schoolID: String = ""
    var avatarURL: String?
    var twtid: String?
    var realname: String?

    var tjuBindingState: Bool = false
    var ecardBindingState: Bool = false
    var libBindingState: Bool = false
    var bicycleBindingState: Bool = false
    var WLANBindingState: Bool = false

    func save() {
        let queue = DispatchQueue(label: "com.wpy.cache")
        queue.async {
            Storage.store(self, in: .group, as: "user.json")
        }
    }

    func load(success: (() -> Void)?, failure: (() -> Void)?) {
        guard Storage.fileExists("user.json", in: .group) else {
            failure?()
            return
        }
        let queue = DispatchQueue(label: "com.wpy.cache")
        queue.async {
            if let user = Storage.retreive("user.json", from: .group, as: TwTUser.self) {
                self.copy(as: user)
                success?()
            } else {
                failure?()
            }
        }
    }

    private func copy(as user: TwTUser) {
        token = user.token
        if username == "" && user.username != "" {
            TWTKeychain.set(username: user.username, of: .root)
        }
        schoolID = user.schoolID
        avatarURL = user.avatarURL
        twtid = user.twtid
        realname = user.realname
        tjuBindingState = user.tjuBindingState
        ecardBindingState = user.ecardBindingState
        libBindingState = user.libBindingState
        bicycleBindingState = user.bicycleBindingState
        WLANBindingState = user.WLANBindingState
    }

    func delete() {
        CacheManager.clear(directory: .group)
        Storage.remove("user.json", from: .group)
        UserDefaults.standard.removeSuite(named: suiteName)
        copy(as: TwTUser())
    }
}
