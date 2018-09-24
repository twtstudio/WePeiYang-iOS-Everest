//
//  File.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/24.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation
import UIKit

class AnswerScrollView: UIScrollView {
    let questionViewParameters = QuestionViewParameters()

//    let answerLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.textAlignment = .left
//        label.numberOfLines = 0
//        label.adjustsFontSizeToFitWidth = true
//        label.font = AnswerViewParameters.aFont
//        return label
//    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.practiceBlue
        label.font = AnswerViewParameters.aFont
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initScrollView()
        
        self.addSubview(label)
//        self.addSubview(answerLabel)
    }
    
    func creatAnswerView(result: String?) {
        if let text = result {
            label.text = text
//            answerLabel.text = answerText
//            AnswerViewParameters.answerTextViewH = answerText.calculateHeightWithConstrained(width: questionViewParameters.questionViewW, font: AnswerViewParameters.aFont)
        } else {
            label.text = "额，答案飞走了"
//            answerLabel.text = ""
        }
        
        label.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(AnswerViewParameters.resultLabelH)
            make.left.top.equalTo(self)
        }
        
//        answerLabel.snp.makeConstraints { (make) in
//            make.width.equalTo(questionViewParameters.questionViewW)
//            make.height.equalTo(AnswerViewParameters.answerTextViewH)
//            make.left.equalTo(self)
//            make.top.equalTo(label).offset(AnswerViewParameters.resultLabelH)
//        }
        self.contentSize = CGSize(width: frame.width, height: AnswerViewParameters.resultLabelH)
//        self.contentSize = CGSize(width: frame.width, height: AnswerViewParameters.resultLabelH + AnswerViewParameters.answerTextViewH)
    }
    
    private func initScrollView() {
        self.backgroundColor = .white
        self.bounces = true
        self.showsVerticalScrollIndicator = true
        self.showsHorizontalScrollIndicator = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
