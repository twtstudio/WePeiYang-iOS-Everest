//
//  WrongView.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/8/7.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class WrongViewCell: UITableViewCell {
    
    /* 课程类型 */
    let classTypeBubbleLabel = UILabel()
    let classTypeDictionary = ["1":"形势与政策", "2":"党课", "3":"网课"] // 考虑之后抽出
    
    /* 题目类型 */
    let questionTypeBubbleLabel = UILabel()
    let questionTypeDictionary = ["0":"单选", "1":"多选", "2":"判断"] // 考虑之后抽出
    
    /* 题目内容 */
    let questionContentLabel = UILabel()
    
    /* 题目选项 */
    var lastExistLabel = UILabel() // 实际用于计算高度
    
    /* 题目答案 */
    let answerContentLabel = UILabel()
    
    /* 收藏图标 */
    let isCollectedIcon = UIButton()
    
    /* 错题图标 */
    let isWrongIcon = UIButton()
    
    /* 单元高度 */
    var cellHeight: CGFloat = 0.0
    
    convenience init(byModel practiceWrong: PracticeWrongModel, withIndex index: Int) {
        self.init(style: .default, reuseIdentifier: "WrongViewCell")
        
        // 课程类型 //
        classTypeBubbleLabel.text = classTypeDictionary[practiceWrong.ques[index].classID]
        classTypeBubbleLabel.frame = CGRect(x: 20, y: 16, width: CGFloat((classTypeBubbleLabel.text?.count)!) * 20 + 24, height: 33)
        classTypeBubbleLabel.setPracticeBubbleLabel()
        contentView.addSubview(classTypeBubbleLabel)
        
        // 题目类型 //
        questionTypeBubbleLabel.text = questionTypeDictionary[practiceWrong.ques[index].type]
        questionTypeBubbleLabel.frame = CGRect(x: classTypeBubbleLabel.frame.maxX + 4, y: classTypeBubbleLabel.frame.origin.y, width: CGFloat((questionTypeBubbleLabel.text?.count)!) * 20 + 24, height: 33)
        questionTypeBubbleLabel.setPracticeBubbleLabel()
        contentView.addSubview(questionTypeBubbleLabel)
        
        // 题目内容 //
        questionContentLabel.text = practiceWrong.ques[index].content
        questionContentLabel.frame.origin = CGPoint(x: classTypeBubbleLabel.frame.origin.x, y: classTypeBubbleLabel.frame.maxY + 20)
        questionContentLabel.setFlexibleHeight(andFixedWidth: deviceWidth - 40)
        contentView.addSubview(questionContentLabel)
        
        // 题目选项 //
        if practiceWrong.ques[index].type != "2" {
            var labelMaxY = 0
            for i in 0..<practiceWrong.ques[index].option.count {
                let questionOptionLabel = UILabel()
                questionOptionLabel.text = "\(String(describing: UnicodeScalar(i + 65)!)). \(practiceWrong.ques[index].option[i])"
                questionOptionLabel.frame.origin = CGPoint(x: questionContentLabel.frame.origin.x, y: questionContentLabel.frame.maxY + CGFloat(labelMaxY + 12))
                questionOptionLabel.textColor = .darkGray
                questionOptionLabel.setFlexibleHeight(andFixedWidth: deviceWidth - 40)
                contentView.addSubview(questionOptionLabel)
                labelMaxY = Int(questionOptionLabel.frame.maxY - questionContentLabel.frame.maxY)
                if i == practiceWrong.ques[index].option.count - 1 { lastExistLabel = questionOptionLabel }
            }
        } else {
            lastExistLabel = questionContentLabel
        }
        
        // 题目答案 //
        answerContentLabel.text = "题目答案: \(practiceWrong.ques[index].answer)"
        answerContentLabel.textColor = .practiceBlue
        answerContentLabel.font = UIFont.boldSystemFont(ofSize: 18)
        answerContentLabel.sizeToFit()
        answerContentLabel.frame.origin = CGPoint(x: questionContentLabel.frame.origin.x, y: lastExistLabel.frame.maxY + 20)
        contentView.addSubview(answerContentLabel)
        
        // 收藏图标 //
        isCollectedIcon.frame = CGRect(x: deviceWidth - 82, y: lastExistLabel.frame.maxY + 18, width: 22, height: 22)
        isCollectedIcon.setImage(#imageLiteral(resourceName: "practiceIsCollected"), for: .normal)
        isCollectedIcon.setImage(#imageLiteral(resourceName: "practiceIsntCollected"), for: .highlighted)
        isCollectedIcon.isHighlighted = practiceWrong.ques[index].isCollected == 0
        isCollectedIcon.addTarget(self, action: #selector(clickIsIcon), for: .touchUpInside)
        contentView.addSubview(isCollectedIcon)
        
        // 错题图标 //
        isWrongIcon.frame = CGRect(x: deviceWidth - 42, y: lastExistLabel.frame.maxY + 18, width: 22, height: 22)
        isWrongIcon.setImage(#imageLiteral(resourceName: "practiceIsWrong"), for: .normal)
        isWrongIcon.setImage(#imageLiteral(resourceName: "practiceIsntWrong"), for: .highlighted) // 考虑错题和收藏的区别应该简化 (等 API 真了)
        isWrongIcon.isHighlighted = practiceWrong.ques[index].isMistake == 0
        isWrongIcon.addTarget(self, action: #selector(clickIsIcon), for: .touchUpInside)
        contentView.addSubview(isWrongIcon)
        
        cellHeight = answerContentLabel.frame.maxY + 20
    }
    
    @objc func clickIsIcon(button: UIButton) {
        let tempButton = UIButton()
        tempButton.setImage(button.image(for: .normal), for: .normal)
        button.setImage(button.image(for: .highlighted), for: .normal)
        button.setImage(tempButton.image(for: .normal), for: .highlighted)
        button.setBounceAnimation()
    }
    
}

extension UILabel {
    // 刷题气泡标签 //
    func setPracticeBubbleLabel() {
        // 注意先设置 UILabel 的 frame 后再调用, 因为 layer 基于 size 才有效
        self.textColor = .practiceBlue
        self.textAlignment = .center
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderColor = UIColor.practiceBlue.cgColor
        self.layer.borderWidth = 1
    }
    
    // 文本自定宽度, 适应高度 //
    func setFlexibleHeight(andFixedWidth width: CGFloat) {
        self.frame.size.width = width
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
        self.sizeToFit()
    }
}
