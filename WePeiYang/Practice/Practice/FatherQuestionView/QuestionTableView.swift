//
//  File.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation


/// 题目及选项TableView父类
class QuestionTableView: UITableView {
    let practiceModel = PracticeModel()
    let exerciseModel = ExerciseModel()
    let questionViewParameters = QuestionViewParameters()
    
    static var selectedAnswer: String?
    var content: String?
    var options: [String?] = []
    var selected: Bool = false
    var usrAnswer: String?
    var rightAns: String?
    var quesType: Int?
    var practiceMode: PracticeMode?
    
    static var selectedAnswerArray: [Bool] = {
        return []
    }()
    var rightAnswers: [Bool] = {
        return []
    }()
    var answerSelected: ((String, Int) -> ([Bool]))?
    var answerResult: ((Int, String) -> Bool)?
    
    let exerciseController = ExerciseCollectionViewController()
  
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        initTableView()
    }

    private func initTableView() {
        self.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        self.separatorStyle = .none
        self.separatorInset = UIEdgeInsetsMake(questionViewParameters.cellH - 10, 0, 0, 0)
        self.showsVerticalScrollIndicator = false
        self.bounces = false
        self.delegate = self
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        answerUpdate()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.delegate = nil
        print("QuestionTableView deinit")
    }

}

extension QuestionTableView: UITableViewDelegate {
    //cell高度自适应
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
        case 0:
            if let question = content {
                let height = question.calculateHeightWithConstrained(width: frame.width, font: questionViewParameters.qFont) < questionViewParameters.minCellH ? questionViewParameters.minCellH : question.calculateHeightWithConstrained(width: frame.width, font: questionViewParameters.qFont)
                return height
            } else {
                return 44
            }
        case 1:
            return 0.02 * deviceHeight
        default:
            if let option = options[indexPath.item - 2] {
                let height = option.calculateHeightWithConstrained(width: questionViewParameters.optionLabelW, font: questionViewParameters.aFont) + questionViewParameters.optionsOffsetY * 2
                let oHeight = height <  questionViewParameters.minOcellH ?  questionViewParameters.minOcellH : height
                return oHeight
            } else {
                return questionViewParameters.cellH
            }
            
        }
    }
}

//做题部分
//extension QuestionTableView {
//    func loadQues(question: String, option: [String], isSelected: Bool, rightAnswer: String, questionType: Int) {
//        //请求数据
//        content = question
//        options = option
//        selected = isSelected
//        rightAns = rightAnswer
//        quesType = questionType
//        practiceMode = .exercise
//    }
//}

//测验部分使用的方法
//extension QuestionTableView {
//    func loadQuiz(question: String, option: [String], questionType: Int) {
//        content = question
//        options = option
//        selected = false
//        rightAns = "Z"
//        quesType = questionType
//        practiceMode = .quiz
//    }
//}

//extension QuestionTableView: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return options.count + 2
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cellIsselected: Bool = false
//        switch indexPath.item {
//        case 0:
//            let questionCell = QuestionCell()
//            questionCell.initQCell(question: content, questionType: quesType)
//            return questionCell
//        case 1:
//            return OptionsCell()
//        default:
//            let optionCell = OptionsCell()
//            let exerciseModel = ExerciseModel()
//            let optionIndex = indexPath.item - 2
//            answerResult = exerciseModel.ansResult(order:rightAns:)
//            
//            if let answer = QuestionTableView.selectedAnswer {
//                if optionIndex == practiceModel.optionToIndexDic[answer] {
//                    cellIsselected = true
//                }
//            }
//            optionCell.initUI(mode: .exercise, ansResult: answerResult!(optionIndex, rightAns!), optionsContent: options[optionIndex], order: optionIndex, isSelected: cellIsselected, finished: selected)
//
//            return optionCell
//        }
//    }
//}


    
    //点击选项
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if quesType == 0 {
//            if selected == true { return }
//            QuestionTableView.selectedAnswer = practiceModel.optionDics[indexPath.item]
//
//            var indexPathArray: [IndexPath] = []
//            for i in 2..<(options.count + 2) {
//                let indexPath = IndexPath(row: i, section: 0)
//                indexPathArray.append(indexPath)
//            }
//            
//            exerciseController.answerupdate(selectedAns: practiceModel.optionDics[indexPath.item]!)
//
//
//            switch practiceMode! {
//            case .exercise:
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "optionSelected"), object: nil)
//            case .quiz:
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "QuizOptionSelected"), object: nil)
//            }
//
//            //        answerUpdate()
//            self.reloadRows(at: indexPathArray, with: .none)
//            //        selected == false
//        }
    
//    }
    
    //闭包传值
//    @objc func answerUpdate() {
//        answerSelected = exerciseModel.answerSelected
//        if let answer = QuestionTableView.selectedAnswer {
//            optionsSelected = answerSelected!(answer, options.count)
//        }else {
//            return
//        }
//    }
