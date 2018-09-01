//
//  UserView.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/7/13.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class UserView: UIView {
    
    /* 用户头像 */
    let userHeadView: UIImageView = {
        let userHeadView = UIImageView()
        
        userHeadView.layer.cornerRadius = 44
        userHeadView.layer.masksToBounds = true
        userHeadView.layer.borderColor = UIColor.gray.cgColor
        userHeadView.layer.borderWidth = 1
        
        return userHeadView
    }()
    
    /* 用户昵称 */
    let userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        
        userNameLabel.textColor = .practiceBlue
        userNameLabel.font = UIFont.systemFont(ofSize: 21)
        
        return userNameLabel
    }()
    
    /* 头衔图标 */
    let userTitleView: UIImageView = {
        let userTitleView = UIImageView()
        
        userTitleView.image = #imageLiteral(resourceName: "practiceTitle")
        
        return userTitleView
    }()
    
    /* 用户头衔 */
    let userTitleLabel = UILabel(text: "", color: .practiceRed)
    
    /* 顶部蓝线 */
    let topHorizontalLine = UIView(color: .practiceBlue)
    
    /* 已练习题目数 */
    let practicedQuestionNumber: UILabel = {
        let practicedQuestionNumber = UILabel()
        
        practicedQuestionNumber.font = UIFont.boldSystemFont(ofSize: 21)
        practicedQuestionNumber.textAlignment = .center
        
        return practicedQuestionNumber
    }()
    
    /* 已练习题目标签 */
    let practicedQuestionLabel: UILabel = {
        let practicedQuestionLabel = UILabel()
        
        practicedQuestionLabel.text = "已练习题目数"
        practicedQuestionLabel.textAlignment = .center
        
        return practicedQuestionLabel
    }()
    
    /* 正确率 */
    let correctRate: UILabel = {
        let correctRate = UILabel()
        
        correctRate.textAlignment = .center
        correctRate.textColor = .practiceRed
        
        return correctRate
    }()
    
    /* 已练习科目数 */
    let practicedCourseNumber: UILabel = {
        let practicedCourseNumber = UILabel()
        
        practicedCourseNumber.font = UIFont.boldSystemFont(ofSize: 21)
        practicedCourseNumber.textAlignment = .center
        
        return practicedCourseNumber
    }()
    
    /* 已练习科目标签 */
    let practicedCourseLabel: UILabel = {
        let practicedCourseLabel = UILabel()
        
        practicedCourseLabel.text = "已练习科目数"
        practicedCourseLabel.textAlignment = .center
        
        return practicedCourseLabel
    }()
    
    /* 底部蓝线 */
    let bottomHorizontalLine = UIView(color: .practiceBlue)
    
    /* 中部蓝线 */
    let verticalLine = UIView(color: .practiceBlue)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        /* 用户信息 */
        // 用户头像 //
        userHeadView.frame = CGRect(x: 30, y: 20, width: 88, height: 88)
        self.addSubview(userHeadView)
        
        // 用户昵称 //
        userNameLabel.frame = CGRect(x: userHeadView.frame.maxX + 20, y: userHeadView.frame.minY, width: deviceWidth - userHeadView.frame.maxX - 50, height: 44)
        self.addSubview(userNameLabel)
        
        // 头衔图标 //
        userTitleView.frame = CGRect(x: userNameLabel.frame.minX, y: userNameLabel.frame.maxY, width: 44, height: 44)
        self.addSubview(userTitleView)
        
        // 用户头衔 //
        userTitleLabel.frame = CGRect(x: userTitleView.frame.maxX, y: userNameLabel.frame.maxY, width: userNameLabel.frame.size.width - userTitleView.frame.size.width, height: 44)
        self.addSubview(userTitleLabel)
        
        /* 练习信息 */
        // 顶部蓝线 //
        topHorizontalLine.frame = CGRect(x: 20, y: userHeadView.frame.maxY + 20, width: deviceWidth - 40, height: 1)
        self.addSubview(topHorizontalLine)
        
        // 已练习题目数 //
        practicedQuestionNumber.frame = CGRect(x: topHorizontalLine.frame.minX, y: topHorizontalLine.frame.maxY + 15, width: deviceWidth / 2 - 20, height: 44)
        self.addSubview(practicedQuestionNumber)
        
        // 已练习题目标签 //
        practicedQuestionLabel.frame = CGRect(x: practicedQuestionNumber.frame.minX, y: practicedQuestionNumber.frame.maxY, width: practicedQuestionNumber.frame.width, height: 33)
        self.addSubview(practicedQuestionLabel)
        
        // 正确率 //
        correctRate.frame = CGRect(x: practicedQuestionLabel.frame.minX, y: practicedQuestionLabel.frame.maxY, width: practicedQuestionLabel.frame.width, height: 33)
        self.addSubview(correctRate)
        
        // 已练习科目数 //
        practicedCourseNumber.frame = CGRect(x: deviceWidth / 2, y: practicedQuestionNumber.frame.minY, width: practicedQuestionNumber.frame.width, height: 44)
        self.addSubview(practicedCourseNumber)
        
        // 已练习科目标签 //
        practicedCourseLabel.frame = CGRect(x: practicedCourseNumber.frame.minX, y: practicedCourseNumber.frame.maxY, width: practicedCourseNumber.frame.width, height: 33)
        self.addSubview(practicedCourseLabel)
        
        // 底部蓝线 //
        bottomHorizontalLine.frame = CGRect(x: topHorizontalLine.frame.minX, y: correctRate.frame.maxY + 15, width: topHorizontalLine.frame.width, height: 1)
        self.addSubview(bottomHorizontalLine)
        
        // 中部蓝线 //
        verticalLine.center = CGPoint(x: deviceWidth / 2, y: topHorizontalLine.frame.maxY + 26)
        verticalLine.frame.size = CGSize(width: 1, height: 88)
        self.addSubview(verticalLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
