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

// MARK: - UITableViewCell
class HomeViewCell: UITableViewCell {
    
    /* 顶部蓝线 */
    private let topHorizontalLine = UIView(color: .practiceBlue)
    
    /* 左侧蓝线 */
    private let leftVerticalLine = UIView(color: .practiceBlue)
    
    /* 单元标题 */
    private let cellTitleLabel = UILabel(text: "", fontSize: 21)
    
    /* 快速选择课程按钮 */
    var bubbleButtonArray = [UIButton]()
    
    /* 当前练习继续按钮 */
    let continueBubbleButton = UIButton()
    
    /* 单元高度 */
    var cellHeight: CGFloat = 0.0
    
    convenience init(byModel practiceStudent: PracticeStudentModel, withStyle style: HomeViewCellStyle) {
        self.init(style: .default, reuseIdentifier: "HomeViewCell")
        let studentData = practiceStudent.data
        
        // 顶部蓝线 //
        topHorizontalLine.frame = CGRect(x: 20, y: 0, width: deviceWidth - 40, height: 1)
        contentView.addSubview(topHorizontalLine)
        
        // 左侧蓝线 //
        leftVerticalLine.frame = CGRect(x: 20, y: 16, width: 3, height: 22)
        contentView.addSubview(leftVerticalLine)
        
        // 单元标题 //
        cellTitleLabel.frame = CGRect(x: leftVerticalLine.frame.maxX + 12, y: topHorizontalLine.frame.maxY + 10, width: deviceWidth / 2, height: 33)
        cellTitleLabel.text = style.rawValue
        contentView.addSubview(cellTitleLabel)
        
        // 根据不同类型设置各自特有视图 //
        switch style {
        
        // 快速选择 //
        case .quickSelect:
            var edgeWidth: CGFloat = 0
            var edgeHeight: CGFloat = 54
            let titleArray = studentData.qSelect
            
            for index in 0..<titleArray.count {
                let bubbleButton = UIButton()
                
                bubbleButton.setPracticeBubbleButton(withTitle: titleArray[index].courseName)
                if edgeWidth + bubbleButton.frame.size.width > deviceWidth - 20 { // 塞不下就换行
                    edgeWidth = 0
                    edgeHeight += bubbleButton.frame.size.height + 16
                }
                bubbleButton.frame.origin = CGPoint(x: 24 + edgeWidth, y: edgeHeight)
                
                bubbleButton.tag = index
                bubbleButton.addTarget(self, action: #selector(clickBubbleButton), for: .touchUpInside)
                contentView.addSubview(bubbleButton)
                
                edgeWidth = bubbleButton.frame.size.width + bubbleButton.frame.origin.x - 20
                bubbleButtonArray.append(bubbleButton)
            }
            
            cellHeight = (bubbleButtonArray.last?.frame.maxY)!
        
        // 最新消息 //
        case .latestInformation:
            let latestInformationMessage = UILabel(text: "\(studentData.latestCourseName)已更新", color: .darkGray)
            latestInformationMessage.sizeToFit()
            latestInformationMessage.frame.origin = CGPoint(x: cellTitleLabel.frame.minX, y: cellTitleLabel.frame.maxY + 10)
            contentView.addSubview(latestInformationMessage)
            
            let latestInformationTime = UILabel(text: String(studentData.latestCourseTimestamp).date(withFormat: "yyyy-MM-dd hh:mm"), color: .gray)
            latestInformationTime.sizeToFit()
            latestInformationTime.frame.origin = CGPoint(x: deviceWidth - latestInformationTime.frame.size.width - 20, y: latestInformationMessage.frame.maxY + 16)
            contentView.addSubview(latestInformationTime)
            
            if latestInformationMessage.frame.size.width + latestInformationTime.frame.size.width > deviceWidth - 55 { // 塞不下就换行
                latestInformationTime.frame.origin.y += latestInformationTime.frame.size.height + 16
            }
            
            cellHeight = latestInformationTime.frame.maxY + 20
            
        // 当前练习 //
        case .currentPractice:
            guard let currentCourseName = studentData.currentCourseName,
                let currentQuesType = studentData.currentQuesType,
                let currentCourseDoneCount = studentData.currentCourseDoneCount,
                let currentCourseQuesCount = studentData.currentCourseQuesCount,
                let currentCourseIndex = studentData.currentCourseIndex else { return }
            
            let currentPracticeCourse = UILabel(text: currentCourseName + PracticeDictionary.questionType[currentQuesType]!, color: .darkGray)
            currentPracticeCourse.sizeToFit()
            currentPracticeCourse.frame.origin = CGPoint(x: cellTitleLabel.frame.minX, y: cellTitleLabel.frame.maxY + 10)
            contentView.addSubview(currentPracticeCourse)
            
            let currentPracticeMessage = UILabel(text: "\(currentCourseDoneCount) / \(currentCourseQuesCount) - 第 \(currentCourseIndex) 题", color: .darkGray)
            currentPracticeMessage.sizeToFit()
            currentPracticeMessage.frame.origin = CGPoint(x: currentPracticeCourse.frame.minX, y: currentPracticeCourse.frame.maxY + 16)
            contentView.addSubview(currentPracticeMessage)
            
            continueBubbleButton.setPracticeBubbleButton(withTitle: "继续")
            continueBubbleButton.frame.origin = CGPoint(x: deviceWidth - continueBubbleButton.frame.size.width - 20, y: currentPracticeCourse.frame.maxY + 12)
            continueBubbleButton.addTarget(self, action: #selector(clickBubbleButton), for: .touchUpInside)
            contentView.addSubview(continueBubbleButton)
            
            cellHeight = continueBubbleButton.frame.maxY + 20
        }
        
        cellHeight = (contentView.subviews.last?.frame.maxY)! + 20
    }
    
    @objc func clickBubbleButton(view: UIView) {
        view.setBounceAnimation()
    }
    
}

// MARK: - UICollectionViewCell
class HomeHeaderCell: UICollectionViewCell {
    
    /* 课程图片 */
    var classImage = UIImageView()
    
    /* 课程名称 */
    var className = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let length: CGFloat = 33
        
        classImage.frame = CGRect(x: (frame.size.width - length) / 2, y: 0, width: length, height: length)
        addSubview(classImage)
        
        className.frame = CGRect(x: 0, y: length + 10, width: frame.width, height: 33)
        className.textAlignment = .center
        addSubview(className)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIButton {
    // 刷题气泡按钮 //
    func setPracticeBubbleButton(withTitle title: String, fontSize: CGFloat = 15) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.practiceBlue, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        self.sizeToFit()
        self.width += 19
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderColor = UIColor.practiceBlue.cgColor
        self.layer.borderWidth = 1
    }
}

extension Array {
    // 数组随机排序 //
    public func shuffle() -> Array {
        var list = self
        for index in 0..<list.count {
            let newIndex = Int(arc4random_uniform(UInt32(list.count - index))) + index
            if index != newIndex { list.swapAt(index, newIndex) }
        }
        return list
    }
}
