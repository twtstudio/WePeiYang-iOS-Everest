//
//  HomeView.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/7/13.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class HomeView: UIView {
    
    /* 顶部课程 */
    static func addTopCourse(withImage image: UIImage, andX x: CGFloat, andWidth width: CGFloat) -> UIButton {
        let topCourseButton = UIButton(frame: CGRect(x: x, y: deviceHeight/24, width: width, height: deviceWidth/10))
        
        topCourseButton.setImage(image, for: .normal)
        
        return topCourseButton
    }
    
    let courseName = ["    党课", "形势与政策", "  网课", "其他    "]
    
    let partyCourse = addTopCourse(withImage: #imageLiteral(resourceName: "practicePartyCourse"), andX: deviceWidth/10, andWidth: deviceWidth/10)
    let situationAndPolicy = addTopCourse(withImage: #imageLiteral(resourceName: "practiceSituationAndPolicy"), andX: deviceWidth * (2/10 + 2/15), andWidth: deviceWidth/10)
    let onlineCourse = addTopCourse(withImage: #imageLiteral(resourceName: "practiceOnlineCourse"), andX: deviceWidth * (3/10 + 4/15), andWidth: deviceWidth/10 + 10)
    let other = addTopCourse(withImage: #imageLiteral(resourceName: "practiceOther"), andX: deviceWidth * (4/10 + 2/5) + 10, andWidth: deviceWidth/10)
    
    func addCourseName(_ name: String, andX x: CGFloat) -> UILabel {
        let courseNameLabel = UILabel(frame: CGRect(x: x, y: deviceHeight/18 + deviceWidth/10, width: deviceWidth/4, height: deviceHeight/18))
        
        courseNameLabel.text = name
        
        return courseNameLabel
    }
    
    // 创建信息块方法
    static func addSession(withY y: CGFloat, andHeight height: CGFloat, andText text: String) -> UIView {
        let sessionView = UIView(frame: CGRect(x: 0, y: y, width: deviceWidth, height: height))
        
        let headLine = UIView(frame: CGRect(x: deviceWidth/20, y: 0, width: deviceWidth * 9/10, height: 1))
        headLine.backgroundColor = UIColor.init(hex6: 0x43AAFA, alpha: 1.0)
        sessionView.addSubview(headLine)
        
        let tinyView = UIView(frame: CGRect(x: deviceWidth/20, y: deviceWidth/20, width: 3, height: deviceHeight/36))
        tinyView.backgroundColor = UIColor.init(hex6: 0x43AAFA, alpha: 1.0)
        sessionView.addSubview(tinyView)
        
        let sessionTitle = UILabel(frame: CGRect(x: deviceWidth/10, y: deviceWidth/20, width: deviceWidth/5, height: deviceHeight/36))
        sessionTitle.text = text
        sessionView.addSubview(sessionTitle)
        
        return sessionView
    }
    
    /* 快速选择 */
    let quickSelectSession = addSession(withY: deviceWidth/3 + 20, andHeight: deviceWidth/2 + 20, andText: "快速选择")
    let quickSelectCourse = ["项目管理学", "美学原理", "高等数学", "从爱因斯坦到霍金宇宙", "古典诗词鉴赏", "社会心理学"]

    // 创建课程气泡按钮 (自动换行) 方法
    func addBubbleCourseButton(intoSuperView superView: UIView, withTitleArray titleArray: [String]) {
        var edgeWidth: CGFloat = 0
        var edgeHeight: CGFloat = deviceWidth/10 + deviceHeight/36
        for index in 0...titleArray.count - 1 {
            let length = CGFloat(titleArray[index].count) * 20
            let bubbleButton = UIButton(frame: CGRect(x: deviceWidth/15 + edgeWidth, y: edgeHeight, width: length + 20, height: deviceHeight/24))
            
            bubbleButton.setTitle(titleArray[index], for: .normal)
            bubbleButton.setTitleColor(UIColor.init(hex6: 0x43AAFA, alpha: 1.0), for: .normal)
            
            bubbleButton.layer.cornerRadius = bubbleButton.frame.height/2
            bubbleButton.layer.borderColor = UIColor.init(hex6: 0x43AAFA, alpha: 1.0).cgColor
            bubbleButton.layer.borderWidth = 1
            
            if deviceWidth/15 + edgeWidth + length > deviceWidth * 14/15 {
                edgeWidth = 0
                edgeHeight += bubbleButton.frame.size.height + deviceWidth/24
                bubbleButton.frame = CGRect(x: deviceWidth/15 + edgeWidth, y: edgeHeight, width: length + 20, height: deviceHeight/24)
            }
            edgeWidth = bubbleButton.frame.size.width + bubbleButton.frame.origin.x - 10
            
            superView.addSubview(bubbleButton)
        }
    }
    
    /* 最新消息 */
    let latestInformationSession = addSession(withY: deviceWidth/3 + 20 + deviceWidth/2 + 20, andHeight: deviceWidth/4 + 20, andText: "最新消息")
    
    let latestInformation: UILabel = {
        let informationLabel = UILabel(frame: CGRect(x: deviceWidth/15, y: deviceWidth/10 + deviceHeight/36, width: deviceWidth*13/15, height: deviceHeight/24))
        
        informationLabel.text = "高等数学下册选择已更新 🌝          1小时前"
        informationLabel.textColor = UIColor.darkGray
        
        return informationLabel
    }()
    
    /* 当前练习 */
    let currentPractice = addSession(withY: deviceWidth/3 + 20 + deviceWidth/2 + 20 + deviceWidth/4 + 20, andHeight: deviceWidth/3, andText: "当前练习")
    
    let currentPracticeInformation: UILabel = {
        let informationLabel = UILabel(frame: CGRect(x: deviceWidth/15, y: deviceWidth/10 + deviceHeight/36, width: deviceWidth*13/15, height: deviceHeight/24))
        
        informationLabel.text = "高等数学下册选择 🤔                       10/110"
        informationLabel.textColor = UIColor.darkGray
        
        return informationLabel
    }()
    
    static func addBubbleButton(withText text: String, andX x: CGFloat, adnY y: CGFloat) -> UIButton {
        let length = CGFloat(text.count) * 20
        let bubbleButton = UIButton(frame: CGRect(x: x, y: y, width: length + 25, height: deviceHeight/24))
        
        bubbleButton.setTitle(text, for: .normal)
        bubbleButton.setTitleColor(UIColor.init(hex6: 0x43AAFA, alpha: 1.0), for: .normal)
        
        bubbleButton.layer.cornerRadius = bubbleButton.frame.height/2
        bubbleButton.layer.borderColor = UIColor.init(hex6: 0x43AAFA, alpha: 1.0).cgColor
        bubbleButton.layer.borderWidth = 1
        
        return bubbleButton
    }
    
    let continueButton = addBubbleButton(withText: "继续", andX: deviceWidth/2 + 10, adnY: deviceWidth/5 + deviceHeight/30)
    let abandonButton = addBubbleButton(withText: "放弃", andX: deviceWidth*2/3 + 30, adnY: deviceWidth/5 + deviceHeight/30)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        self.addSubview(partyCourse)
        self.addSubview(situationAndPolicy)
        self.addSubview(onlineCourse)
        self.addSubview(other)
        for courseNameIndex in 0...courseName.count - 1 {
            let courseNameLabel = addCourseName(courseName[courseNameIndex], andX: CGFloat(courseNameIndex) * deviceWidth/4)
            courseNameLabel.textAlignment = .center
            self.addSubview(courseNameLabel)
        }
        
        self.addSubview(quickSelectSession)
        addBubbleCourseButton(intoSuperView: quickSelectSession, withTitleArray: quickSelectCourse)
        
        self.addSubview(latestInformationSession)
        latestInformationSession.addSubview(latestInformation)
        
        self.addSubview(currentPractice)
        currentPractice.addSubview(currentPracticeInformation)
        currentPractice.addSubview(continueButton)
        currentPractice.addSubview(abandonButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
