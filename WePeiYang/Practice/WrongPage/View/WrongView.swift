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
    var lastDynamicLabel = UILabel() // 用于计算动态高度
    
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
        var classID = "2"
        let courseID = Int(practiceWrong.data.ques[index].courseID)!
        if courseID == 1 {
            classID = "1"
        } else if courseID > 21 { classID = "3" }
        
        classTypeBubbleLabel.frame.origin = CGPoint(x: 20, y: 16)
        classTypeBubbleLabel.setPracticeBubbleLabel(withText: classTypeDictionary[classID]!)
        contentView.addSubview(classTypeBubbleLabel)
        
        // 题目类型 //
        questionTypeBubbleLabel.frame.origin = CGPoint(x: classTypeBubbleLabel.frame.maxX + 4, y: classTypeBubbleLabel.frame.origin.y)
        questionTypeBubbleLabel.setPracticeBubbleLabel(withText: questionTypeDictionary[practiceWrong.data.ques[index].quesType]!)
        contentView.addSubview(questionTypeBubbleLabel)
        
        // 题目内容 //
        questionContentLabel.text = practiceWrong.data.ques[index].content
        questionContentLabel.frame.origin = CGPoint(x: classTypeBubbleLabel.frame.origin.x, y: classTypeBubbleLabel.frame.maxY + 20)
        questionContentLabel.setFlexibleHeight(andFixedWidth: deviceWidth - 40)
        contentView.addSubview(questionContentLabel)
        
        // 题目选项 //
        if practiceWrong.data.ques[index].quesType != "2" {
            var labelMaxY = 0
            for i in 0..<practiceWrong.data.ques[index].option.count {
                let questionOptionLabel = UILabel()
                questionOptionLabel.text = "\(String(describing: UnicodeScalar(i + 65)!)). \(practiceWrong.data.ques[index].option[i])" // 利用 Unicode 获得选项字母序号
                questionOptionLabel.frame.origin = CGPoint(x: questionContentLabel.frame.origin.x, y: questionContentLabel.frame.maxY + CGFloat(labelMaxY + 12))
                questionOptionLabel.textColor = .darkGray
                questionOptionLabel.setFlexibleHeight(andFixedWidth: deviceWidth - 40)
                contentView.addSubview(questionOptionLabel)
                labelMaxY = Int(questionOptionLabel.frame.maxY - questionContentLabel.frame.maxY)
                if i == practiceWrong.data.ques[index].option.count - 1 { lastDynamicLabel = questionOptionLabel }
            }
        } else {
            lastDynamicLabel = questionContentLabel
        }
        
        // 题目答案 //
        if practiceWrong.data.ques[index].quesType != "2" {
            answerContentLabel.text = "题目答案: \(practiceWrong.data.ques[index].answer)"
        } else {
            switch practiceWrong.data.ques[index].answer {
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
        isCollectedIcon.frame = CGRect(x: deviceWidth - 82, y: lastDynamicLabel.frame.maxY + 18, width: 22, height: 22)
        
        if practiceWrong.data.ques[index].isCollected == 1 {
            isCollectedIcon.setSwitchIcon(forNormalAndHighlighted: #imageLiteral(resourceName: "practiceIsCollected"), andSelected: #imageLiteral(resourceName: "practiceIsntCollected"))
        } else {
            isCollectedIcon.setSwitchIcon(forNormalAndHighlighted: #imageLiteral(resourceName: "practiceIsntCollected"), andSelected: #imageLiteral(resourceName: "practiceIsCollected"))
        }
        
        contentView.addSubview(isCollectedIcon)
        
        // 错题图标 //
        isWrongIcon.frame = CGRect(x: deviceWidth - 42, y: lastDynamicLabel.frame.maxY + 18, width: 22, height: 22)
        isWrongIcon.setSwitchIcon(forNormalAndHighlighted: #imageLiteral(resourceName: "practiceIsWrong"), andSelected: #imageLiteral(resourceName: "practiceIsntWrong"))
        contentView.addSubview(isWrongIcon)
        
        cellHeight = answerContentLabel.frame.maxY + 20
    }
    
}

extension UILabel {
    // 刷题气泡标签 //
    func setPracticeBubbleLabel(withText text: String, fontSize: CGFloat = 15) {
        self.text = text
        self.textColor = .practiceBlue
        self.textAlignment = .center
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.sizeToFit()
        self.width += 19
        self.height += 12
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

extension UIImage {
    // 图片着色 //
    func tint(color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return tintedImage
    }
}
