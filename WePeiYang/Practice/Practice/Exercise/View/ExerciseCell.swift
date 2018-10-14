//
//  ExerciseCell.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/23.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation
import UIKit

class ExerciseCell: UICollectionViewCell {
    let questionViewParameters = QuestionViewParameters()

    var questionView = ExerciseQuesView(frame: .zero, style: .plain)
//    var answerView = AnswerScrollView(frame: .zero)
    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.practiceBlue
        label.font = AnswerViewParameters.aFont
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        //题目
        self.addSubview(questionView)
        //答案
//        self.addSubview(answerView)
    }

    func initExerciseCell() {
        let offsety = 0.15 * deviceHeight
        questionView.snp.makeConstraints { (make) in
            make.width.equalTo(questionViewParameters.questionViewW)
            make.height.equalTo(questionViewParameters.questionViewH)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-offsety)
        }
    }
    
    func loadQues(answer: String, ques: String, options: [String], selected: Bool, rightAns: String, qType: Int) {
        print(answer)
        questionView.loadQues(usrAns: answer, question: ques, option: options, isSelected: selected, rightAnswer: rightAns, questionType: qType)
    }
    
    func addAnswerView(result: String?, rightAnswer: String?) {
        label.textColor = UIColor.practiceBlue
        if result != rightAnswer {
            label.textColor = UIColor.readRed
        }
        
        if let text = rightAnswer {
            label.text = text
        } else {
            label.text = "额，答案飞走了"
        }
        
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(AnswerViewParameters.resultLabelH)
            make.left.equalTo(questionView)
            make.bottom.equalTo(self).offset(-AnswerViewParameters.answerTextViewH)

        }
    }
    
    func removeAnswerView() {
//        answerView.removeFromSuperview()
        label.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
