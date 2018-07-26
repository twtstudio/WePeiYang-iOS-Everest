//
//  File.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/24.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation
import UIKit

struct AnswerViewParameters {
    static let aFont = UIFont.systemFont(ofSize: 16)
    static let resultLabelH = 0.05 * deviceHeight
    static let answerTextViewH = 0.2 * deviceHeight
    static let answerViewH = 0.25 * deviceHeight
}

class AnswerScrollView: UIScrollView {
    
    let answerTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = AnswerViewParameters.aFont
        return textView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = AnswerViewParameters.aFont
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initScrollView()
        
        self.addSubview(label)
        self.addSubview(answerTextView)
    }
    
    func creatAnswerView(result: String?, answer: String?) {
        if let text = result, let answerText = answer {
            label.text = text
            answerTextView.text = answerText
        } else {
            label.text = ""
            answerTextView.text = ""
        }
        
        label.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(AnswerViewParameters.resultLabelH)
            make.left.top.equalTo(self)
        }
        
        answerTextView.snp.makeConstraints { (make) in
            make.width.equalTo(QuestionViewParameters.questionViewW)
            make.height.equalTo(AnswerViewParameters.answerTextViewH)
            make.left.equalTo(self)
            make.top.equalTo(label).offset(AnswerViewParameters.resultLabelH)
        }
    }
    
    private func initScrollView() {
        self.bounces = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
