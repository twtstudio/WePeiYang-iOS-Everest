//
//  CacheFilenameKey.swift
//  WePeiYang
//
//  Created by Halcao on 2018/2/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

enum CacheFilenameKey: String {
    // library card
    case libUserInfo

    var name: String {
        return self.rawValue + ".json"
    }
}
