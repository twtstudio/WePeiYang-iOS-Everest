//
//  ExamModel.swift
//  WePeiYang
//
//  Created by Halcao on 2018/12/30.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct ExamModel: Codable {
    let id: String
    let name: String
    let type: String
    let date: String
    let arrange: String
    let location: String
    let seat: String
    let state: String
    let ext: String
}
