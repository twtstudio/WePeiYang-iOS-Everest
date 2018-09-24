//
//  options.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

enum PracticeMode {
    case exercise
    case quiz
}

struct QuestionDetails {
    var id: Int?
    var classId: Int?
    var courseId: Int?
    var type: Int?
    var content: String?
    var option: [String]?
    var correctAnswer: String?
    var isCollected: Int?
    var isMistake: Int?
}

struct Question {
    var status: Int?
    var quesDetail: QuestionDetails?
}



struct Answer {
    var ques_id: Int?
    var answer: String?
    var type: Int?
}

struct Result {
    var ques_id: Int?
    var ques_type: Int?
    var is_true: Int?
    var answer: String?
    var true_answer: String?
}

struct Results {
    var score: Int?
    var data: [Result]?
}

struct PracticeModel {
    let optionDics: [Int: String] = [2: "A",
                                     3: "B",
                                     4: "C",
                                     5: "D",
                                     6: "E",
                                     7: "F"]
    
    let optionToIndexDic: [String: Int] = ["A": 0,
                                           "B": 1,
                                           "C": 2,
                                           "D": 3,
                                           "E": 4,
                                           "F": 5]
    
    /// 将答案String转化为[Bool]
    ///
    /// - Parameter ans: 答案String
    /// - Returns: 按选项顺序排列的[Bool], 选择了为true, 未选择为false
    func ansToArray(ans: String) -> [Bool] {
        var array: [Bool] = []
        let startingValue = Int(("A" as UnicodeScalar).value) // 65
        for i in 0 ..< 6 {
            array.append(ans.contains(Character(UnicodeScalar(i + startingValue)!)))
        }
        return array
    }
}

