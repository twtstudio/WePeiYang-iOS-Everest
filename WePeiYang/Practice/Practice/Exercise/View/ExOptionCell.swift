//
//  ExOptionCell.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/17.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

class ExOptionCell: OptionsCell {
    func initUI(ansResult: Bool, optionsContent: String?, order: Int, isSelected: Bool, finished: Bool) {
        if finished {
            if ansResult == true {
                optionIcon.image = selectedbtnImgs[order]
            }else {
                if isSelected == false {
                    optionIcon.image = btnImages[order]
                }else {
                    optionIcon.image = #imageLiteral(resourceName: "error")
                }
            }
        }else {
            optionIcon.image = btnImages[order]
        }
        //传入选项字符串
        optionContent = optionsContent
        setupUI()
    }
    
    func initMultipleChoiceUI(iconType: Int, order: Int, optionsContent: String?) {
        switch iconType {
        case 0:
            //选择正确
            optionIcon.image = #imageLiteral(resourceName: "correct")
        case 1:
            //未选择的正确答案
            optionIcon.image = selectedbtnImgs[order]
        case 2:
            //选择了的错误答案
            optionIcon.image = #imageLiteral(resourceName: "error")
        default:
            //未选择的错误答案
            optionIcon.image = btnImages[order]
        }
        optionContent = optionsContent
        setupUI()
    }
}
