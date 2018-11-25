//
//  ExerciseQuesView.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/9/17.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import Foundation

/// 是QuestionTableView的子类 是练习模式界面下的QuestionTableView
class ExerciseQuesView: QuestionTableView {
    var optionIndex: Int?
    var checked: Bool = {
        return false
    }()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        NotificationCenter.default.addObserver(self, selector: #selector(checkMultipleAns), name: NSNotification.Name(rawValue: "Check Multiple Choice Answer"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Check Multiple Choice Answer"), object: nil)
    }
    
    /// 接口，从外部传入练习模式数据
    ///
    /// - Parameters:
    ///   - question: 题目字符串
    ///   - option: 选项字符串数组
    ///   - isSelected: 是否已经选择了选项
    func loadQues(usrAns: String, question: String, option: [String], isSelected: Bool, rightAnswer: String, questionType: Int) {
        //传入数据
        self.dataSource = self
        content = question
        options = option
        selected = isSelected
        quesType = questionType
        rightAns = rightAnswer
        usrAnswer = usrAns
        rightAnswers = practiceModel.ansToArray(ans: rightAns!)
        QuestionTableView.selectedAnswerArray = practiceModel.ansToArray(ans: usrAnswer!)
    }
}

extension ExerciseQuesView: UITableViewDataSource {
    func numberOfRowsInSectionrOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            let questionCell = QuestionCell()
            questionCell.initQCell(question: content, questionType: quesType)
            return questionCell
        case 1:
            return ExOptionCell()
        default:
            optionIndex = indexPath.item - 2
            if quesType == 1 {
                return multipleTypeCell()
            } else {
                return singleTypeCell()
            }
        }
    }
}

extension ExerciseQuesView {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        optionIndex = indexPath.item - 2
        if selected == true { return }

        if quesType == 1 {
            //记录答案的[Bool]
            QuestionTableView.selectedAnswerArray[optionIndex!] = !QuestionTableView.selectedAnswerArray[optionIndex!]
//            let indexpath = IndexPath(row: indexPath.item, section: 0)
            updateData()
        } else {
            QuestionTableView.selectedAnswer = practiceModel.optionDics[indexPath.item]
            updateData()
        }
    }
    
    /// 重新加载
    private func updateData() {
        var indexPathArray: [IndexPath] = []
        for i in 2..<(options.count + 2) {
            let indexPath = IndexPath(row: i, section: 0)
            indexPathArray.append(indexPath)
        }
        
        if quesType != 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "optionSelected"), object: nil)
        }
        self.reloadRows(at: indexPathArray, with: .none)
    }
    
    /// 确定单选题cell的UI显示
    /// 题号icon一次性只能选择 一 个
    /// - Returns: 单选cell
    private func singleTypeCell() -> ExOptionCell {
        let optionCell = ExOptionCell()
        let exerciseModel = ExerciseModel()
        
        var cellIsselected: Bool = false
        answerResult = exerciseModel.ansResult(order:rightAns:)
        
        if let answer = usrAnswer {
            if optionIndex == practiceModel.optionToIndexDic[answer] {
                cellIsselected = true
            }
        }
        optionCell.initUI(ansResult: answerResult!(optionIndex!, rightAns!), optionsContent: options[optionIndex!], order: optionIndex!, isSelected: cellIsselected, finished: selected)
        
        return optionCell
    }
    
    /// 确定多选题cell的UI显示
    /// 题号icon可以一次性显示选择多个
    /// - Returns: 多选cell
    private func multipleTypeCell() -> ExOptionCell {
        let optionCell = ExOptionCell()
        var type: Int = 3

        if checked == true {
            QuestionTableView.selectedAnswerArray = practiceModel.ansToArray(ans: usrAnswer!)
        }

        if checked == true || selected == true {
            if rightAnswers[optionIndex!] && QuestionTableView.selectedAnswerArray[optionIndex!] {
                type = 0
            } else if rightAnswers[optionIndex!] {
                type = 1
            } else if QuestionTableView.selectedAnswerArray[optionIndex!] {
                type = 2
            } else {
                type = 3
            }
        } else {
            if QuestionTableView.selectedAnswerArray[optionIndex!] {
                type = 1
            }
        }

        optionCell.initMultipleChoiceUI(iconType: type, order: optionIndex!, optionsContent: options[optionIndex!])
        
        return optionCell
    }
    
    
    /// 查看多选答案是否正确
    @objc private func checkMultipleAns() {
        checked = true
        rightAnswers = practiceModel.ansToArray(ans: rightAns!)
        checked = false
    }
}
