//
//  UserInfoModel.swift
//  WePeiYang
//
//  Created by 安宇 on 2021/1/13.
//  Copyright © 2021 twtstudio. All rights reserved.
//


import Foundation

// MARK: - Empty
struct UserInfoModel: Codable {
    let errorCode: Int
    let message: String
    let result: UserInfo

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case message, result
    }
}

struct UserInfo: Codable {
    var userNumber, nickname, telephone, email: String
    var token, role, realname, gender: String
    var department, major, stuType, avatar: String
}
