//
//  PTQuizOptionCell.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/24.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

class PTQuizOptionCell: PTOptionsCell {
    func initUI( optionsContent: String?, order: Int, isSelected: Bool, isFinished: Bool) {
        if isSelected {
            optionIcon.image = selectedbtnImgs[order]
        }else {
            optionIcon.image = btnImages[order]
        }
        //传入选项字符串
        optionContent = optionsContent
        setupUI()
    }
}
