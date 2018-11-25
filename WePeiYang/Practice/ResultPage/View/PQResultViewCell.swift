//
//  ResultView.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/27.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - UITableViewCell
class PQResultViewCell: UITableViewCell {
    
    /* 题目内容 */
    let questionContentLabel = UICopyLabel()
    
    /* 题目选项 */
    var lastDynamicLabel = UILabel() // 用于计算动态高度
    
    /* 题目答案 */
    let answerContentLabel = UILabel()
    
    /* 用户答案 */
    let usrAnsContentLabel = UILabel()
    
    /* 收藏图标 */
    let isCollectedIcon = UIButton()
    
    /* 错题图标 */
    let isMistakeIcon: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "practiceIsWrong"), for: .normal)
        return btn
    }()
    
    /* 单元高度 */
    var cellHeight: CGFloat = 0.0
    
    convenience init(byModel pQuizResultData: [PQuizResultData], withIndex index: Int) {
        self.init(style: .default, reuseIdentifier: "ResultViewCell")
        let wrongData = pQuizResultData[index]
        
        // 题目内容 //
        questionContentLabel.text = "\(index + 1). " + wrongData.content
        questionContentLabel.frame.origin = CGPoint(x: 20, y: 16)
        questionContentLabel.setFlexibleHeight(andFixedWidth: deviceWidth - 40)
        contentView.addSubview(questionContentLabel)
        
        // 题目选项 //
        if wrongData.quesType != "2" {
            var labelMaxY = 0
            for i in 0..<wrongData.option.count {
                let questionOptionLabel = UILabel()
                questionOptionLabel.text = "\(String(describing: UnicodeScalar(i + 65)!)). \(wrongData.option[i])" // 利用 Unicode 获得选项字母序号
                questionOptionLabel.frame.origin = CGPoint(x: questionContentLabel.frame.origin.x, y: questionContentLabel.frame.maxY + CGFloat(labelMaxY + 12))
                questionOptionLabel.textColor = .darkGray
                questionOptionLabel.setFlexibleHeight(andFixedWidth: deviceWidth - 40)
                contentView.addSubview(questionOptionLabel)
                labelMaxY = Int(questionOptionLabel.frame.maxY - questionContentLabel.frame.maxY)
                if i == wrongData.option.count - 1 { lastDynamicLabel = questionOptionLabel }
            }
        } else {
            lastDynamicLabel = questionContentLabel
        }
        
        // 题目答案 //
        if wrongData.quesType != "2" {
            answerContentLabel.text = "正确答案: \(wrongData.answer)"
        } else {
            switch wrongData.answer {
            case "A":
                answerContentLabel.text = "正确答案: √"
                usrAnsContentLabel.text = "你的答案: √"
            case "B":
                answerContentLabel.text = "正确答案: ×"
                usrAnsContentLabel.text = "你的答案: ×"
            default:
                return
            }
        }
        
        if wrongData.isTrue == 1 {
            usrAnsContentLabel.textColor = .practiceBlue
        } else {
            usrAnsContentLabel.textColor = .practiceRed
        }
        
        answerContentLabel.textColor = .practiceBlue
        answerContentLabel.font = UIFont.boldSystemFont(ofSize: 16)
        answerContentLabel.sizeToFit()
        answerContentLabel.frame.origin = CGPoint(x: questionContentLabel.frame.origin.x, y: lastDynamicLabel.frame.maxY + 21)
        contentView.addSubview(answerContentLabel)
        
        if wrongData.errorOption == "" {
            usrAnsContentLabel.text = "你的答案：未做"
        } else {
            usrAnsContentLabel.text = "你的答案：\(wrongData.errorOption)"
        }
        usrAnsContentLabel.font = UIFont.boldSystemFont(ofSize: 16)
        usrAnsContentLabel.sizeToFit()
        usrAnsContentLabel.frame.origin = CGPoint(x: questionContentLabel.frame.origin.x + 120, y: lastDynamicLabel.frame.maxY + 21)
        contentView.addSubview(usrAnsContentLabel)
        
        // 收藏图标 //
        isCollectedIcon.frame = CGRect(x: deviceWidth - 42, y: lastDynamicLabel.frame.maxY + 18, width: 22, height: 22)
        
        if wrongData.isCollected == 1 {
            isCollectedIcon.setSwitchIcon(forNormalAndHighlighted: #imageLiteral(resourceName: "practiceIsCollected"), andSelected: #imageLiteral(resourceName: "practiceIsntCollected"))
        } else {
            isCollectedIcon.setSwitchIcon(forNormalAndHighlighted: #imageLiteral(resourceName: "practiceIsntCollected"), andSelected: #imageLiteral(resourceName: "practiceIsCollected"))
        }
        
        contentView.addSubview(isCollectedIcon)
        
        cellHeight = answerContentLabel.frame.maxY + 20
    }
}
