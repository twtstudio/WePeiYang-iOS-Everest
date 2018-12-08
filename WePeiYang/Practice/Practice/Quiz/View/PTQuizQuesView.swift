//
//  PTQuizQuesView.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/17.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation
class PTQuizQuesView: PTQuestionTableView {
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadQuiz(question: String, option: [String], questionType: Int, usrAns: String) {
        self.dataSource = self
        content = question
        options = option
        selected = false
        quesType = questionType
        usrAnswer = usrAns
        PTQuestionTableView.selectedAnswerArray = practiceModel.ansToArray(ans: usrAns)
    }
}


extension PTQuizQuesView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let questionCell = PTQuestionCell()
            
            questionCell.initQCell(question: content, questionType: quesType)
            
            return questionCell
        case 1:
            return PTOptionsCell()
        default:
            let optionCell = (tableView.dequeueReusableCell(withIdentifier: "optionCell") as? PTQuizOptionCell) ?? PTQuizOptionCell()
//            let optionCell = PTQuizOptionCell()
            let optionIndex = indexPath.item - 2
            let array = PTQuestionTableView.selectedAnswerArray
            
            optionCell.initUI(optionsContent: options[optionIndex], order: optionIndex, isSelected: array[optionIndex], isFinished: selected)
            return optionCell
        }
    }
}


extension PTQuizQuesView {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if selected { return }
        if indexPath.item <= 1 { return }
        let index = indexPath.item - 2
        
        if quesType == 1 {
            //多选题响应
            PTQuestionTableView.selectedAnswerArray[index].toggle()
        } else {
            //单选或判断题响应
            if PTQuestionTableView.selectedAnswerArray[index] {
                PTQuestionTableView.selectedAnswerArray[index] = false
            } else {
                PTQuestionTableView.selectedAnswerArray = PTQuestionTableView.selectedAnswerArray.map { (z) -> Bool in
                    return false
                }
                PTQuestionTableView.selectedAnswerArray[index] = true
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "QuizOptionSelected"), object: nil)
        
        self.reloadData()
    }
}
