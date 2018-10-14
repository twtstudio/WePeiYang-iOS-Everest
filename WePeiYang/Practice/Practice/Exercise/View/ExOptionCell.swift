//
//  ExOptionCell.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/17.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

class ExOptionCell: OptionsCell {
    
    /// 接口，传入选项cell的UI信息
    ///
    /// - Parameters:
    ///   - ansResult: <#ansResult description#>
    ///   - optionsContent: <#optionsContent description#>
    ///   - order: <#order description#>
    ///   - isSelected: <#isSelected description#>
    ///   - finished: <#finished description#>
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
    
    /// 接口，传入 多选题 选项icon显示模式信息
    ///
    /// - Parameters:
    ///   - iconType: 0-选择正确 1-未选择的正答 2-选择错误 3-未选择的错误答案
    ///   - order: 选项顺序（从0开始）
    ///   - optionsContent: 该顺序选项的文本字符串
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
