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
    var username: String? // 天外天username
    var schoolID: String? // 学号
    var avatarURL: String? // 头像url
    var twtid: String? // 天外天id
    var realname: String? // 真实姓名
    var feedbackID: Int? // 校务id
    
    // 用户信息相关
    var major: String? // 专业
    var department: String? // 学院
    var telephone: String? // 手机号
    var email: String? // 邮箱号
    var newToken: String?
    
    var tjuBindingState: Bool = false
    var ecardBindingState: Bool = false
    var libBindingState: Bool = false
    var bicycleBindingState: Bool = false
    var WLANBindingState: Bool = false
    var QRcodeBindingState: Bool = false
    // 用户信息绑定
    var UserInfoState: Bool = false
    
    required init(from decoder: Decoder) {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            token = try container.decodeIfPresent(String.self, forKey: .token)
            username = try container.decodeIfPresent(String.self, forKey: .username)
            schoolID = try container.decodeIfPresent(String.self, forKey: .schoolID)
            avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL)
            twtid = try container.decodeIfPresent(String.self, forKey: .twtid)
            realname = try container.decodeIfPresent(String.self, forKey: .realname)
            feedbackID = try container.decodeIfPresent(Int.self, forKey: .feedbackID)
            
            tjuBindingState = try container.decodeIfPresent(Bool.self, forKey: .tjuBindingState) ?? false
            ecardBindingState = try container.decodeIfPresent(Bool.self, forKey: .ecardBindingState) ?? false
            libBindingState = try container.decodeIfPresent(Bool.self, forKey: .libBindingState) ?? false
            bicycleBindingState = try container.decodeIfPresent(Bool.self, forKey: .bicycleBindingState) ?? false
            WLANBindingState = try container.decodeIfPresent(Bool.self, forKey: .WLANBindingState) ?? false
            UserInfoState = try container.decodeIfPresent(Bool.self, forKey: .UserInfoState) ?? false
            
            major = try container.decodeIfPresent(String.self, forKey: .major)
            department = try container.decodeIfPresent(String.self, forKey: .department)
            telephone = try container.decodeIfPresent(String.self, forKey: .telephone)
            email = try container.decodeIfPresent(String.self, forKey: .email)
            newToken = try container.decodeIfPresent(String.self, forKey: .newToken)
        } catch let err {
            log(err)
        }
    }
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
        username = user.username
        TWTKeychain.set(username: user.username, of: .root)
        schoolID = user.schoolID
        avatarURL = user.avatarURL
        twtid = user.twtid
        realname = user.realname
        feedbackID = user.feedbackID
        tjuBindingState = user.tjuBindingState
        ecardBindingState = user.ecardBindingState
        libBindingState = user.libBindingState
        bicycleBindingState = user.bicycleBindingState
        WLANBindingState = user.WLANBindingState
        UserInfoState = user.UserInfoState
        
        department = user.department
        major = user.major
        telephone = user.telephone
        email = user.email
        newToken = user.newToken
    }
    
    func delete() {
        CacheManager.clear(directory: .group)
        Storage.remove("user.json", from: .group)
        UserDefaults.standard.removeSuite(named: suiteName)
        copy(as: TwTUser())
    }
}
