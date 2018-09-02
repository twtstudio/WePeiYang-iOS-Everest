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


class QuestionCell: UITableViewCell {
    let questionViewParameters = QuestionViewParameters()

    let qLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.numberOfLines = 0
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .white
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = .clear
        
        contentView.addSubview(qLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initQCell(question: String?) {
        if let text = question {
            qLabel.font = questionViewParameters.qFont
            qLabel.text = question
//            qLabel.frame = CGRect(x: 0, y: 0, width: cellWidth, height: text.calculateHeightWithConstrained(width: 80, font: qFont))
            height = text.calculateHeightWithConstrained(width: CGFloat(questionViewParameters.questionViewW), font: questionViewParameters.qFont)
            qLabel.snp.makeConstraints { (make) in
                make.width.equalTo(questionViewParameters.questionViewW)
                make.height.equalTo(height)
                make.left.top.equalTo(self)
            }

        } else {
            //数据为空时怎么办（待填坑）
            
            
        }
    }
}
