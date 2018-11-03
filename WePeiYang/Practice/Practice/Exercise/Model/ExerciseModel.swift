//
//  ExerciseModel.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/8/9.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

class ExerciseModel {
    let practiceModel = PracticeModel()
    //    func answerSelected(answer: String, optionCount: Int) -> [Bool] {
    //        var array: [Bool] = []
    //        for _ in 0..<optionCount {
    //            array.append(false)
    //        }
    //        if let index = practiceModel.optionToIndexDic[answer] {
    //            array[index] = true
    //            return array
    //        }else {
    //            return array
    //        }
    //    }
    func ansResult(order: Int, rightAns: String) -> Bool {
        if practiceModel.optionDics[order + 2] == rightAns {
            return true
        }else {
            return false
        }
    }
}

enum isCorrect {
    case right
    case wrong
    case unknown
}
enum Direction {
    case left
    case right
    case none
}

enum ExerciseMode {
    case memorize
    case exercise
}

struct Guard {
    //哨兵
    var iscollected: Bool = false
    var ischecked: Bool = false
    var isMistake: Bool = false
    var iscorrect: isCorrect = .unknown
    var answer: String?
    var selected: Bool = false
}


