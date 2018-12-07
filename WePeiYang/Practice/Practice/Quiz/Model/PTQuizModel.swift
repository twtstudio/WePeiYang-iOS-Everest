//
//  QuizModel.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/7.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

struct PTQuizQuestion {
    var id: Int?
    var courseId: Int?
    var quesType: Int?
    var content: String?
    var options: [String]?
    var isCollected: Int?
}

struct PTQuizResultData {
    let quesID: String
    let quesType, content: String
    let option: [String]
    let answer: String
    let isCollected: Int
    let errorOption: String
    let isDone: Int
    let isTrue: Int
}

struct PTQuizResult {
    var score: Int = 0
    var timestamp: Int = 0
    var correctNum: Int = 0
    var errNum: Int = 0
    var notDoneNum: Int = 0
    var practiceTime: String = ""
    var results: [PTQuizResultData] = []
}

