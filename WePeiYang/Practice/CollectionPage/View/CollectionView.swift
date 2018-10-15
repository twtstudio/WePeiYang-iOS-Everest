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
    
    /* 题目类型 */
    let questionTypeBubbleLabel = UILabel()
    
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
    
    convenience init(byModel practiceCollection: PracticeCollectionModel, withIndex index: Int) {
        self.init(style: .default, reuseIdentifier: "CollectionViewCell")
        let collectionData = practiceCollection.data[index]
        
        // 课程类型 //
        let classID = PracticeFigure.getClassID(byCourseID: Int(collectionData.courseID)!)
        classTypeBubbleLabel.frame.origin = CGPoint(x: 20, y: 16)
        classTypeBubbleLabel.setPracticeBubbleLabel(withText: PracticeDictionary.classType[classID]!)
        contentView.addSubview(classTypeBubbleLabel)
        
        // 题目类型 //
        questionTypeBubbleLabel.frame.origin = CGPoint(x: classTypeBubbleLabel.frame.maxX + 4, y: classTypeBubbleLabel.frame.origin.y)
        questionTypeBubbleLabel.setPracticeBubbleLabel(withText: PracticeDictionary.questionType[collectionData.quesType]!)
        contentView.addSubview(questionTypeBubbleLabel)
        
        // 题目内容 //
        questionContentLabel.text = collectionData.content
        questionContentLabel.frame.origin = CGPoint(x: classTypeBubbleLabel.frame.origin.x, y: classTypeBubbleLabel.frame.maxY + 20)
        questionContentLabel.setFlexibleHeight(andFixedWidth: deviceWidth - 40)
        contentView.addSubview(questionContentLabel)
        
        // 题目选项 //
        if collectionData.quesType != "2" {
            var labelMaxY = 0
            for i in 0..<collectionData.option.count {
                let questionOptionLabel = UILabel()
                questionOptionLabel.text = "\(String(describing: UnicodeScalar(i + 65)!)). \(collectionData.option[i])"
                questionOptionLabel.frame.origin = CGPoint(x: questionContentLabel.frame.origin.x, y: questionContentLabel.frame.maxY + CGFloat(labelMaxY + 12))
                questionOptionLabel.textColor = .darkGray
                questionOptionLabel.setFlexibleHeight(andFixedWidth: deviceWidth - 40)
                contentView.addSubview(questionOptionLabel)
                labelMaxY = Int(questionOptionLabel.frame.maxY - questionContentLabel.frame.maxY)
                if i == collectionData.option.count - 1 { lastDynamicLabel = questionOptionLabel }
            }
        } else {
            lastDynamicLabel = questionContentLabel
        }
        
        // 题目答案 //
        if collectionData.quesType != "2" {
            answerContentLabel.text = "题目答案: \(collectionData.answer)"
        } else {
            switch collectionData.answer {
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
