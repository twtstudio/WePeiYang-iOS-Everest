//
//  ExerciseModel.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/26.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

class ExerciseModel {
    let precticeModel = PracticeModel()
    
    func answerSelected(answer: String) -> [Bool] {
        var optionSelected = [false, false, false, false]
        let answerIndex = precticeModel.optionToIndexDic[answer]!
        optionSelected[answerIndex] = true
        return optionSelected
    }
//    func changeOptionImg() {
//        answerSelected = {(isSelected) -> Bool in
//            let selected = !isSelected
//            return selected
//        }
//    }    
}
