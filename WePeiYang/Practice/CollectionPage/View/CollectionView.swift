//
//  CollectionView.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/9/1.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class CollectionViewCell: UITableViewCell {
    
    /* 课程类型 */
    let classTypeBubbleLabel = UILabel()
    let classTypeDictionary = ["1":"形势与政策", "2":"党课", "3":"网课"] // 考虑之后抽出
    
    /* 题目类型 */
    let questionTypeBubbleLabel = UILabel()
    let questionTypeDictionary = ["0":"单选", "1":"多选", "2":"判断"] // 考虑之后抽出
    
    /* 题目内容 */
    let questionContentLabel = UILabel()
    
    /* 题目选项 */
    var lastDynamicLabel = UILabel() // 用于计算动态高度
    
    /* 题目答案 */
    let answerContentLabel = UILabel()
    
    /* 收藏图标 */
    let isCollectedIcon = UIButton()
    
    /* 单元高度 */
    var cellHeight: CGFloat = 0.0
    
    convenience init(byModel practiceWrong: PracticeCollectionModel, withIndex index: Int) {
        self.init(style: .default, reuseIdentifier: "CollectionViewCell")
        
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
                if i == practiceWrong.ques[index].option.count - 1 { lastDynamicLabel = questionOptionLabel }
            }
        } else {
            lastDynamicLabel = questionContentLabel
        }
        
        // 题目答案 //
        if practiceWrong.ques[index].type != "2" {
            answerContentLabel.text = "题目答案: \(practiceWrong.ques[index].answer)"
        } else {
            switch practiceWrong.ques[index].answer {
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
        isCollectedIcon.setImage(#imageLiteral(resourceName: "practiceIsCollected"), for: .normal)
        isCollectedIcon.setImage(#imageLiteral(resourceName: "practiceIsCollected"), for: .highlighted)
        isCollectedIcon.setImage(#imageLiteral(resourceName: "practiceIsntCollected"), for: .selected)
        contentView.addSubview(isCollectedIcon)
        
        cellHeight = answerContentLabel.frame.maxY + 20
    }
    
}
