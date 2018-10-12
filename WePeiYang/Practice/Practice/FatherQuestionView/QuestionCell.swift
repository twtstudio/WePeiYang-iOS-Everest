//
//  Cells.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/21.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// 题目（不含选项）Cell的父类
class QuestionCell: UITableViewCell {
    let questionViewParameters = QuestionViewParameters()

    let qLabel: UICopyLabel = {
        let label = UICopyLabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.numberOfLines = 0
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let quesLabelH = 15
    let quesTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.practiceBlue
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.practiceBlue.cgColor
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = .clear
        
        contentView.addSubview(qLabel)
        contentView.addSubview(quesTypeLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initQCell(question: String?, questionType: Int?) {
        if let text = question {
            qLabel.font = questionViewParameters.qFont
            qLabel.text = "            " + text
            height = text.calculateHeightWithConstrained(width: CGFloat(questionViewParameters.questionViewW), font: questionViewParameters.qFont)
            qLabel.snp.makeConstraints { (make) in
                make.width.equalTo(questionViewParameters.questionViewW)
                make.height.equalTo(height)
                make.left.top.equalTo(self)
            }
            
            if questionType == 0 {
                quesTypeLabel.text = "单选"
            }else if questionType == 1 {
                quesTypeLabel.text = "多选"
            }else {
                quesTypeLabel.text = "判断"
            }
            quesTypeLabel.layer.cornerRadius = CGFloat(quesLabelH / 2)
            quesTypeLabel.snp.makeConstraints { (make) in
                make.width.equalTo(35)
                make.height.equalTo(quesLabelH)
                make.top.equalTo(qLabel).offset(1)
                make.left.equalTo(qLabel).offset(5)
            }
        } else {
            //数据为空时怎么办（待填坑）
            
            
        }
    }
}
