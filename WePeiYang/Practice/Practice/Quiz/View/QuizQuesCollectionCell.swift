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
    
    func loadQues(ques: String, options: [String], qType: Int, selectedAns: String) {
        questionView.loadQuiz(question: ques, option: options, questionType: qType, usrAns: selectedAns)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupGetScoreButton() {
        let button: UIButton = {
            let btn = UIButton()
            btn.backgroundColor = UIColor.practiceBlue
            btn.setTitle("提交啦", for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.layer.borderWidth = 3
            return btn
        }()
        
        button.addTarget(self, action: #selector(postButtonTapped(_:)), for: .touchUpInside)
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-10)
            make.width.equalTo(0.9 * deviceWidth)
            make.height.equalTo(0.15 * deviceHeight)
        }
    }
    
    @objc func postButtonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "postButtonTapped"), object: nil)
    }

}
