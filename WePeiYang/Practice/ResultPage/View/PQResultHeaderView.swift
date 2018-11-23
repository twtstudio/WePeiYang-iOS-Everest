//
//  PQResultHeaderView.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/11/23.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

// MARK: UIView
class PQResultHeadView: UIView {
    
    /* 蓝色背景 */
    private let headBackgroundView: UIView = {
        let headBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: 220))
        headBackgroundView.backgroundColor = .practiceBlue
        
        // 设置圆角 //
        headBackgroundView.setCorners([.bottomLeft, .bottomRight], radius: 20)
        
        return headBackgroundView
    }()
    
    /* 本次答题标签 */
    private let scoreNameLabel = UILabel(text: "本次测验得分", color: .white)
    
    /* 本次答题数量 */
    private let scoreNameNumber = UILabel(text: "25", color: .white)
    
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
        
        scoreNameLabel.frame = CGRect(x: 0, y: 0, width: deviceWidth, height: 44)
        scoreNameLabel.textAlignment = .center
        addSubview(scoreNameLabel)
        scoreNameNumber.frame = CGRect(x: 0, y: scoreNameLabel.frame.maxY, width: deviceWidth, height: 44)
        scoreNameNumber.textAlignment = .center
        scoreNameNumber.font = .boldSystemFont(ofSize: 24)
        addSubview(scoreNameNumber)
        

        correctRateLabel.frame = CGRect(x: 0, y: scoreNameNumber.frame.maxY, width: deviceWidth, height: 44)
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
    
    func initHeader(score: String, correctNum: String, practiceTime: String) {
        scoreNameNumber.text = score
        practiceTimeNumber.text = practiceTime
    }
    
}
