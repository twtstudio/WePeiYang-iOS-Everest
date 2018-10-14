//
//  Parameters.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/12.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

/// QuestionView所用到的所有UI参数
struct QuestionViewParameters {
    //TableView
    let questionViewW = 0.9 * deviceWidth
    let questionViewH = 0.48 * deviceHeight
    let cellH = 0.04 * deviceHeight
    let optionGap = 0.06 * deviceHeight
    let minCellH = 35 / 736 * deviceHeight
    let minOcellH = 60 / 736 * deviceHeight
    
    //选项
    let optionLabelW = 0.7 * deviceWidth
    let optionsOffsetY = 0.007 * deviceHeight
    let aFont = UIFont.systemFont(ofSize: 16)
    
    //题目字体
    let qFont = UIFont.systemFont(ofSize: 18)
    
}

struct AnswerViewParameters {
    static let aFont = UIFont.systemFont(ofSize: 16)
    static let resultLabelH = 0.05 * deviceHeight
    static var answerTextViewH = 0.2 * deviceHeight
    static let answerViewH = 0.25 * deviceHeight
}

