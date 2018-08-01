//
//  HomeView.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/7/13.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

enum HomeViewCellStyle: String {
    case quickSelect = "快速选择"
    case latestInformation = "最新消息"
    case currentPractice = "当前练习"
}

class HomeViewCell: UITableViewCell {
    
    /* 顶部蓝线 */
    let topHorizontalLine = UIView(color: .practiceBlue)
    
    /* 左侧蓝线 */
    let leftVerticalLine = UIView(color: .practiceBlue)
    
    /* 单元标题 */
    let cellTitleLabel = UILabel(text: "", fontSize: 21)
    
    // 单元高度 //
    var cellHeight: CGFloat = 0.0
    
    // 创建课程气泡按钮 (自动换行) 方法 //
    func addBubbleCourseButton(intoSuperView superView: UIView, withTitleArray titleArray: [String]) {
        var edgeWidth: CGFloat = 0
        var edgeHeight: CGFloat = 54
        for index in 0...titleArray.count - 1 {
            let length = CGFloat(titleArray[index].count) * 20
            let bubbleButton = UIButton(frame: CGRect(x: 24 + edgeWidth, y: edgeHeight, width: length + 24, height: 33))
            
            bubbleButton.setTitle(titleArray[index], for: .normal)
            bubbleButton.setTitleColor(.practiceBlue, for: .normal)
            
            bubbleButton.layer.cornerRadius = bubbleButton.frame.height / 2
            bubbleButton.layer.borderColor = UIColor.practiceBlue.cgColor
            bubbleButton.layer.borderWidth = 1
            
            if 20 + edgeWidth + length > deviceWidth - 40 {
                edgeWidth = 0
                edgeHeight += bubbleButton.frame.size.height + 16
                bubbleButton.frame = CGRect(x: 24 + edgeWidth, y: edgeHeight, width: length + 24, height: 33)
            }
            edgeWidth = bubbleButton.frame.size.width + bubbleButton.frame.origin.x - 20
            
            superView.addSubview(bubbleButton)
        }
    }
    
    convenience init(withStyle style: HomeViewCellStyle) {
        self.init(style: .default, reuseIdentifier: style.rawValue)
        
        // 顶部蓝线 //
        topHorizontalLine.frame = CGRect(x: 20, y: 0, width: deviceWidth - 40, height: 1)
        self.contentView.addSubview(topHorizontalLine)
        
        // 左侧蓝线 //
        leftVerticalLine.frame = CGRect(x: 20, y: 16, width: 3, height: 22)
        self.contentView.addSubview(leftVerticalLine)
        
        // 单元标题
        cellTitleLabel.frame = CGRect(x: leftVerticalLine.frame.maxX + 12, y: topHorizontalLine.frame.maxY + 10, width: deviceWidth / 2, height: 33)
        cellTitleLabel.text = style.rawValue
        self.contentView.addSubview(cellTitleLabel)
        
        // 根据不同类型设置各自特有视图 //
        switch style {
        
        // 快速选择 //
        case .quickSelect:
            addBubbleCourseButton(intoSuperView: self.contentView, withTitleArray: ["项目管理学", "美学原理", "高等数学", "从爱因斯坦到霍金宇宙", "古典诗词鉴赏", "社会心理学"]) // 考虑写在 Controller 里
        
        // 最新消息 //
        case .latestInformation:
            let latestInformationMessage = UILabel(text: "高等数学下册选择已更新", color: .darkGray)
            latestInformationMessage.sizeToFit()
            latestInformationMessage.frame.origin = CGPoint(x: cellTitleLabel.frame.minX, y: cellTitleLabel.frame.maxY + 10)
            self.contentView.addSubview(latestInformationMessage)
            
            let latestInformationTime = UILabel(text: "1 小时前", color: .darkGray)
            latestInformationTime.sizeToFit()
            latestInformationTime.frame.origin = CGPoint(x: deviceWidth - latestInformationTime.frame.size.width - 20, y: cellTitleLabel.frame.maxY + 10)
            self.contentView.addSubview(latestInformationTime)
            
        // 当前练习 //
        case .currentPractice:
            let currentPracticeCourse = UILabel(text: "高等数学下册选择", color: .darkGray)
            currentPracticeCourse.sizeToFit()
            currentPracticeCourse.frame.origin = CGPoint(x: cellTitleLabel.frame.minX, y: cellTitleLabel.frame.maxY + 10)
            self.contentView.addSubview(currentPracticeCourse)
            
            let currentPracticeMessage = UILabel(text: "10 / 1010", color: .darkGray)
            currentPracticeMessage.sizeToFit()
            currentPracticeMessage.frame.origin = CGPoint(x: deviceWidth - currentPracticeMessage.frame.size.width - 20, y: cellTitleLabel.frame.maxY + 10)
            self.contentView.addSubview(currentPracticeMessage)
        }
        cellHeight = (self.contentView.subviews.last?.frame.maxY)! + 20
    }
    
}

class HomeHeaderCell: UICollectionViewCell {
    
    /* 课程图片 */
    var courseImage = UIImageView()
    
    /* 课程名称 */
    var courseName = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let length: CGFloat = 33
        
        courseImage.frame = CGRect(x: (self.width - length) / 2, y: 0, width: length, height: length)
        self.addSubview(courseImage)
        
        courseName.frame = CGRect(x: 0, y: length + 10, width: frame.width, height: 33)
        courseName.textAlignment = .center
        self.addSubview(courseName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
