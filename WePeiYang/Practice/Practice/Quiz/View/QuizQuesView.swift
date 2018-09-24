//
//  QuizQuesView.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/17.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation
class QuizQuesView: QuestionTableView {
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadQuiz(question: String, option: [String], questionType: Int) {
        content = question
        options = option
        selected = false
        rightAns = "Z"
        quesType = questionType
    }
}

extension QuizQuesView {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}

extension QuizQuesView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIsselected: Bool = false
        switch indexPath.item {
        case 0:
            let questionCell = QuestionCell()
            questionCell.initQCell(question: content, questionType: quesType)
            return questionCell
        case 1:
            return QuizOptionCell()
        default:
            let optionCell = QuizOptionCell()
            let exerciseModel = ExerciseModel()
            let optionIndex = indexPath.item - 2
            answerResult = exerciseModel.ansResult(order:rightAns:)
            
            if let answer = QuestionTableView.selectedAnswer {
                if optionIndex == practiceModel.optionToIndexDic[answer] {
                    cellIsselected = true
                }
            }
            optionCell.initUI(optionsContent: options[optionIndex], order: optionIndex, isSelected: cellIsselected, isFinished: selected)
            
            return optionCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selected {return}
        if quesType == 1 {
            //多选
        } else {
            QuestionTableView.selectedAnswer = practiceModel.optionDics[indexPath.item - 2]
        }
    }
    
}
