//
//  DetailBook.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/11/23.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct DetailBook: Codable {
    let id, isbn, title: String
    let authorPrimary: [String]
    let publisher, year: String
    let holding: [Holding]
}

struct Holding: Codable {
    let callno, state, local: String
}
