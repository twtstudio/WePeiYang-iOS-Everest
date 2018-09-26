//
//  HistoryView.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/9/11.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class HistoryViewCell: UITableViewCell {
    
    /* 练习类型 */
    let practiceTypeBubbleLabel = UILabel()
    
    /* 题目类型 */
    let questionTypeBubbleLabel = UILabel()
    
    /* 课程类型 */
    let classTypeLabel = UILabel()
    
    /* 课程名称 */
    let courseNameLabel = UILabel()
    
    /* 练习进度 */
    let practiceProgressLabel = UILabel()
    
    /* 正确率 */
    let correctRateLabel = UILabel()
    
    /* 练习时间 */
    let practiceTimeLabel = UILabel()
    
    /* 单元高度 */
    var cellHeight: CGFloat = 0.0
    
    convenience init(byModel practiceHistory: PracticeHistoryModel, withIndex index: Int) {
        self.init(style: .default, reuseIdentifier: "HistoryViewCell")
        let historyData = practiceHistory.data[index]
        
        // 练习类型 //
        practiceTypeBubbleLabel.frame.origin = CGPoint(x: 20, y: 16)
        practiceTypeBubbleLabel.setPracticeBubbleLabel(withText: PracticeDictionary.practiceType[historyData.type]!)
        contentView.addSubview(practiceTypeBubbleLabel)
        
        // 题目类型 //
        if let quesType = historyData.quesType {
            questionTypeBubbleLabel.frame.origin = CGPoint(x: practiceTypeBubbleLabel.frame.maxX + 4, y: practiceTypeBubbleLabel.frame.origin.y)
            questionTypeBubbleLabel.setPracticeBubbleLabel(withText: PracticeDictionary.questionType[quesType]!)
            contentView.addSubview(questionTypeBubbleLabel)
        }
        
        // 课程类型 //
        classTypeLabel.text = PracticeDictionary.classType[historyData.classID]
        classTypeLabel.frame.origin = CGPoint(x: practiceTypeBubbleLabel.frame.origin.x, y: practiceTypeBubbleLabel.frame.maxY + 20)
        classTypeLabel.sizeToFit()
        contentView.addSubview(classTypeLabel)
        
        // 课程名称 //
        if historyData.classID != "1" { // 形势与政策不需要显示
            courseNameLabel.text = historyData.courseName
            courseNameLabel.frame.origin = CGPoint(x: classTypeLabel.frame.maxX + 4, y: classTypeLabel.frame.origin.y)
            courseNameLabel.sizeToFit()
            contentView.addSubview(courseNameLabel)
        }
        
        switch historyData.type {
        case "0": // 顺序练习
            // 练习进度 //
            if let doneCount = historyData.doneCount,
                let quesCount = historyData.quesCount {
                practiceProgressLabel.text = "进度: \(doneCount) / \(quesCount) - 第 \(historyData.doneIndex) 题"
                practiceProgressLabel.textColor = .darkGray
                practiceProgressLabel.sizeToFit()
                practiceProgressLabel.frame.origin = CGPoint(x: classTypeLabel.frame.origin.x, y: classTypeLabel.frame.maxY + 20)
                contentView.addSubview(practiceProgressLabel)
            }
        case "1": // 模拟考试
            // 正确率 //
            if let correctRate = historyData.score {
                correctRateLabel.textColor = .red
                let correctRateText = NSMutableAttributedString(string: "正确率: \(correctRate)%") // 使用富文本改变字体
                correctRateText.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, 5))
                correctRateLabel.attributedText = correctRateText
                correctRateLabel.frame.origin = CGPoint(x: classTypeLabel.frame.origin.x, y: classTypeLabel.frame.maxY + 20)
                correctRateLabel.sizeToFit()
                contentView.addSubview(correctRateLabel)
            }
        default:
            return
        }
        
        // 练习时间 //
        practiceTimeLabel.text = historyData.timestamp.date(withFormat: "yyyy-MM-dd hh:mm")
        practiceTimeLabel.textColor = .gray
        practiceTimeLabel.sizeToFit()
        practiceTimeLabel.frame.origin = CGPoint(x: deviceWidth - practiceTimeLabel.frame.size.width - 20, y: classTypeLabel.frame.maxY + 20)
        
        if practiceProgressLabel.frame.size.width + practiceTimeLabel.frame.size.width > deviceWidth - 40 || correctRateLabel.frame.size.width + practiceTimeLabel.frame.size.width > deviceWidth - 40 { // 塞不下就换行
            practiceTimeLabel.frame.origin.y += practiceTimeLabel.frame.size.height + 16
        }
        
        contentView.addSubview(practiceTimeLabel)
        
        cellHeight = practiceTimeLabel.frame.maxY + 20
    }
    
    func getDate(byTimestamp timestamp: String, withFormat format: String) -> String {
        let timeInterval = TimeInterval(timestamp)!
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
    
}

extension String {
    // 时间戳字符串格式化 //
    func date(withFormat format: String) -> String {
        let timeInterval = TimeInterval(self)!
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
}
