//
//  WrongView.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/8/7.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

enum QuestionType: String {
    case single = "单选"
    case multiple = "多选"
    case judge = "判断"
}

class WrongViewCell: UITableViewCell {
    
    /* 课程类型 */
    let courseTypeBubble = UILabel()
    
    /* 题目类型 */
    let questionTypeBubble = UILabel()
    
    /* 题目内容 */
    let questionContentLabel = UILabel()
    
    
    /* 题目答案 */
    let answerContentLabel = UILabel()
    
    /* 收藏图标 */
    let isCollectedIcon = UIButton()
    
    /* 错题图标 */
    let isWrongIcon = UIButton()
    
    /* 单元高度 */
    var cellHeight: CGFloat = 0.0
    
    convenience init(withType type: QuestionType) {
        self.init(style: .default, reuseIdentifier: type.rawValue)
        
        // 课程类型 //
        
        self.addSubview(questionTypeBubble)
    }
    
}
