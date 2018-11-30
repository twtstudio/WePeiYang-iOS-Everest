//
//  TwTKeychain.swift
//  WePeiYang
//
//  Created by Halcao on 2017/5/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import KeychainAccess

struct TWTKeychain {
    static let USERNAME_PREFIX = "un_"
    static let PASSWORD_PREFIX = "pw_"
    enum ServiceType: String {
        case root
        case library
        case tju
        case network
        case bicycle
        case ecard
    }

    private init () {}
    static let appKey = "YPUzdhNPOa8TeozPw0wb"
    static let appSecret = "TyxNrASaYhSjb7XqGDmSAsQBFi3p4L"

    private static var keychains = [String: Keychain]()
    private static var keychain: Keychain? {
        guard TwTUser.shared.token != nil,
            let username = TwTUser.shared.username,
            !username.isEmpty else {
                return nil
        }

        if let keychain = keychains[username] {
            return keychain
        } else {
            let keychain = Keychain(service: "cn.edu.twt.mobile-\(username)", accessGroup: "group.WePeiYang").synchronizable(true)
            keychains[username] = keychain
            return keychain
        }
    }

    static func username(for service: ServiceType) -> String? {
        return keychain?[usernameKey(of: service)]
    }

    static func password(for service: ServiceType) -> String? {
        return keychain?[passwordKey(of: service)]
    }

    static func set(password: String?, of service: ServiceType) {
        set(value: password, of: passwordKey(of: service))
    }

    static func set(username: String?, of service: ServiceType) {
        set(value: username, of: usernameKey(of: service))
    }

    static func set(username: String?, password: String?, of service: ServiceType) {
        set(username: username, of: service)
        set(password: password, of: service)
    }

    static func erase(_ service: ServiceType) {
        set(username: nil, password: nil, of: service)
    }

    private static func usernameKey(of service: ServiceType) -> String {
        return USERNAME_PREFIX + service.rawValue
    }

    private static func passwordKey(of service: ServiceType) -> String {
        return PASSWORD_PREFIX + service.rawValue
    }

    private static func set(value: String?, of key: String) {
        do {
            if let value = value {
                try keychain?.set(value, key: key)
            } else {
                try keychain?.remove(key)
            }
        } catch let err {
            log(err)
        }
    }
}
