//
//  ResultView.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/27.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

// MARK: UIView
class ResultHeadView: UIView {
    
    /* 蓝色背景 */
    private let headBackgroundView: UIView = {
        let headBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: 220))
        headBackgroundView.backgroundColor = .practiceBlue
        
        // 设置圆角 //
        headBackgroundView.setCorners([.bottomLeft, .bottomRight], radius: 20)
        
        return headBackgroundView
    }()
    
    /* 本次答题标签 */
    private let answerNameLabel = UILabel(text: "本次答题数", color: .white)
    
    /* 本次答题数量 */
    private let answerNameNumber = UILabel(text: "25", color: .white)
    
    /* 正确率 */
    private let correctRateLabel = UILabel(text: "正确率: 4%", color: .white)
    
    /* 练习时间标签 */
    private let practiceTimeLabel = UILabel(text: "练习时间", color: .white)
    
    /* 练习时间数字 */
    private let practiceTimeNumber = UILabel(text: "01:24", color: .white)
    
    /* 中部白线 */
    private let verticalLine = UIView(color: .white)
    
    /* 错题标签 */
    private let wrongLabel = UILabel(text: "错题数", color: .white)
    
    /* 错题数字 */
    private let wrongNumber = UILabel(text: "24", color: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(headBackgroundView)
        
        answerNameLabel.frame = CGRect(x: 0, y: 0, width: deviceWidth, height: 44)
        answerNameLabel.textAlignment = .center
        addSubview(answerNameLabel)
        
        answerNameNumber.frame = CGRect(x: 0, y: answerNameLabel.frame.maxY, width: deviceWidth, height: 44)
        answerNameNumber.textAlignment = .center
        answerNameNumber.font = .boldSystemFont(ofSize: 24)
        addSubview(answerNameNumber)
        
        correctRateLabel.frame = CGRect(x: 0, y: answerNameNumber.frame.maxY, width: deviceWidth, height: 44)
        correctRateLabel.textAlignment = .center
        addSubview(correctRateLabel)
        
        practiceTimeLabel.frame = CGRect(x: 0, y: correctRateLabel.frame.maxY, width: deviceWidth / 2, height: 44)
        practiceTimeLabel.textAlignment = .center
        addSubview(practiceTimeLabel)
        
        practiceTimeNumber.frame = CGRect(x: 0, y: practiceTimeLabel.frame.maxY, width: deviceWidth / 2, height: 44)
        practiceTimeNumber.textAlignment = .center
        addSubview(practiceTimeNumber)
        
        verticalLine.frame = CGRect(x: deviceWidth / 2, y: practiceTimeLabel.frame.origin.y + 22, width: 1, height: 44)
        addSubview(verticalLine)
        
        wrongLabel.frame = CGRect(x: deviceWidth / 2, y: correctRateLabel.frame.maxY, width: deviceWidth / 2, height: 44)
        wrongLabel.textAlignment = .center
        addSubview(wrongLabel)
        
        wrongNumber.frame = CGRect(x: deviceWidth / 2, y: wrongLabel.frame.maxY, width: deviceWidth / 2, height: 44)
        wrongNumber.textAlignment = .center
        addSubview(wrongNumber)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UITableViewCell
class ResultViewCell: UITableViewCell {
    
    /* 题目内容 */
    let questionContentLabel = UICopyLabel()
    
    /* 题目选项 */
    var lastDynamicLabel = UILabel() // 用于计算动态高度
    
    /* 题目答案 */
    let answerContentLabel = UILabel()
    
    /* 收藏图标 */
    let isCollectedIcon = UIButton()
    
    /* 单元高度 */
    var cellHeight: CGFloat = 0.0
    
    convenience init(byModel practiceWrong: PracticeWrongModel, withIndex index: Int) {
        self.init(style: .default, reuseIdentifier: "ResultViewCell")
        let wrongData = practiceWrong.data[index]
        
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
            answerContentLabel.text = "题目答案: \(wrongData.answer)"
        } else {
            switch wrongData.answer {
            case "A":
                answerContentLabel.text = "题目答案: √"
            case "B":
                answerContentLabel.text = "题目答案: ×"
            default:
                return
            }
        }
        
        answerContentLabel.textColor = .practiceBlue
        answerContentLabel.font = UIFont.boldSystemFont(ofSize: 18)
        answerContentLabel.sizeToFit()
        answerContentLabel.frame.origin = CGPoint(x: questionContentLabel.frame.origin.x, y: lastDynamicLabel.frame.maxY + 20)
        contentView.addSubview(answerContentLabel)
        
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
