//
//  options.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

struct Question {
    var id: Int?
    var course_id: Int?
    var type: Int?
    var content: String?
    var option: [Dictionary<String, String>]?
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


