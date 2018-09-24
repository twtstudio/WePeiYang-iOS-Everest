//
//  QuizQuesCell.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/8.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

class QuizQuesCollectionCell: UICollectionViewCell {
    let questionViewParameters = QuestionViewParameters()
    
    var questionView = QuizQuesView(frame: .zero, style: .plain)
    //    var answerView = AnswerScrollView(frame: .zero)
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        //题目
        self.addSubview(questionView)
    }
    
    func initQuizCell() {
        let offsety = 0.15 * deviceHeight
        questionView.snp.makeConstraints { (make) in
            make.width.equalTo(questionViewParameters.questionViewW)
            make.height.equalTo(questionViewParameters.questionViewH)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-offsety)
        }
    }
    
    func loadQues(ques: String, options: [String], selected: Bool, rightAns: String, qType: Int) {
        questionView.loadQuiz(question: ques, option: options, questionType: qType)
//        (question: ques, option: options, isSelected: false, rightAnswer: "Z", questionType: qType)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
