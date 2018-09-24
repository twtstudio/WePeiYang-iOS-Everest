//
//  QuizModel.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/7.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct QuizQuestion {
    var id: Int?
    var courseId: Int?
    var quesType: Int?
    var content: String?
    var options: [String]?
    var isCollected: Int?
}
