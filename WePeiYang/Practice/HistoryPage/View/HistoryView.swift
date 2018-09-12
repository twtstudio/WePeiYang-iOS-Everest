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
    let practiceTypeDictionary = ["0":"顺序练习", "1":"模拟考试"] // 考虑之后抽出
    
    /* 题目类型 */
    let questionTypeBubbleLabel = UILabel()
    let questionTypeDictionary = ["0":"单选", "1":"多选", "2":"判断"] // 考虑之后抽出
    
    /* 课程类型 */
    let classTypeLabel = UILabel()
    let classTypeDictionary = ["1":"形势与政策", "2":"党课", "3":"网课"] // 考虑之后抽出
    
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
        
        // 练习类型 //
        practiceTypeBubbleLabel.frame.origin = CGPoint(x: 20, y: 16)
        practiceTypeBubbleLabel.setPracticeBubbleLabel(withText: practiceTypeDictionary[practiceHistory.data[index].type]!)
        contentView.addSubview(practiceTypeBubbleLabel)
        
        // 题目类型 //
        if let quesType = practiceHistory.data[index].quesType {
            questionTypeBubbleLabel.frame.origin = CGPoint(x: practiceTypeBubbleLabel.frame.maxX + 4, y: practiceTypeBubbleLabel.frame.origin.y)
            questionTypeBubbleLabel.setPracticeBubbleLabel(withText: questionTypeDictionary[quesType]!)
            contentView.addSubview(questionTypeBubbleLabel)
        }
        
        // 课程类型 //
        classTypeLabel.text = classTypeDictionary[practiceHistory.data[index].classID]
        classTypeLabel.frame.origin = CGPoint(x: practiceTypeBubbleLabel.frame.origin.x, y: practiceTypeBubbleLabel.frame.maxY + 20)
        classTypeLabel.sizeToFit()
        contentView.addSubview(classTypeLabel)
        
        // 课程名称 //
        var courseName = practiceHistory.data[index].courseName
        if courseName.hasPrefix("第") { courseName.removeFirst(4) }
        courseNameLabel.text = courseName
        courseNameLabel.frame.origin = CGPoint(x: classTypeLabel.frame.maxX + 4, y: classTypeLabel.frame.origin.y)
        courseNameLabel.sizeToFit()
        contentView.addSubview(courseNameLabel)
        
        // 练习进度 //
        if let doneCount = practiceHistory.data[index].doneCount,
            let quesCount = practiceHistory.data[index].quesCount {
            practiceProgressLabel.text = "\(doneCount) / \(quesCount) - 第 \(practiceHistory.data[index].doneIndex) 题"
            practiceProgressLabel.textColor = .darkGray
            practiceProgressLabel.sizeToFit()
            practiceProgressLabel.frame.origin = CGPoint(x: deviceWidth - practiceProgressLabel.frame.size.width - 20, y: classTypeLabel.frame.origin.y)
            contentView.addSubview(practiceProgressLabel)
        }
        
        // 正确率 //
        if let correctRate = practiceHistory.data[index].score {
            correctRateLabel.textColor = .red
            let correctRateText = NSMutableAttributedString(string: "正确率 \(correctRate)%") // 使用富文本改变字体
            correctRateText.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, 4))
            correctRateLabel.attributedText = correctRateText
            correctRateLabel.frame.origin = CGPoint(x: classTypeLabel.frame.origin.x, y: classTypeLabel.frame.maxY + 20)
            correctRateLabel.sizeToFit()
            contentView.addSubview(correctRateLabel)
        }
        
        // 练习时间 //
        practiceTimeLabel.text = self.getDate(byTimestamp: practiceHistory.data[index].timestamp, withFormat: "yyyy-MM-dd hh:mm")
        practiceTimeLabel.textColor = .gray
        practiceTimeLabel.sizeToFit()
        practiceTimeLabel.frame.origin = CGPoint(x: deviceWidth - practiceTimeLabel.frame.size.width - 20, y: classTypeLabel.frame.maxY + 20)
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
