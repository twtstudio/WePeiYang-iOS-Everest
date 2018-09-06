//
//  ClientItem.swift
//  WePeiYang
//
//  Created by Halcao on 2017/2/22.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import Foundation

struct ClientItem: Codable {
    var name: String
    var phone: String
    var isFavorite = false
    var owner: String
}
