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

struct PQuizResultData {
    let quesID: String
    let quesType, content: String
    let option: [String]
    let answer: String
    let isCollected: Int
    let errorOption: String
    let isDone: Int
    let isTrue: Int
}

struct PQuizResult {
    var score: String = ""
    var timestamp: String = ""
    var correctNum: String = ""
    var errNum: String = ""
    var notDoneNum: String = ""
    var practiceTime: String = ""
    var results: [PQuizResultData] = []
}

