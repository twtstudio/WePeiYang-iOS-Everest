//
//  File.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

class ExerciseModel {
//    let practiceModel = PracticeModel()
//    func answerSelected(answer: String, optionCount: Int) -> [Bool] {
//        var array: [Bool] = []
//        for _ in 0..<optionCount {
//            array.append(false)
//        }
//        if let index = practiceModel.optionToIndexDic[answer] {
//            array[index] = true
//            return array
//        }else {
//            return array
//        }
//    }
}

struct QuestionViewParameters {
    let questionViewW = 0.9 * deviceWidth
    let questionViewH = 0.48 * deviceHeight
    let cellH = 0.04 * deviceHeight
    let optionGap = 0.06 * deviceHeight
    let minCellH = 35 / 736 * deviceHeight
    let minOcellH = 60 / 736 * deviceHeight
    
    //选项
    let optionLabelW = 0.7 * deviceWidth
    let optionsOffsetY = 0.007 * deviceHeight
    let aFont = UIFont.systemFont(ofSize: 17)
    
    //答案字体
    let qFont = UIFont.systemFont(ofSize: 17)
}

//这个数组的长度应该由选项个数决定
var optionsSelected = [false, false, false, false]
class QuestionTableView: UITableView {
    let practiceModel = PracticeModel()
    let exerciseModel = ExerciseModel()
    let questionViewParameters = QuestionViewParameters()
    
    var content: String?
    var options: [String?] = []
    var selected: Bool = false
    var rightAns: String?
    
    static var selectedAnswer: String?
    var answerSelected: ((String, Int) -> ([Bool]))?
  
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        // 而且content 和 options 最好在传进来之前就解包。这里这两个参数之后要改为非可选型

        initTableView()
    }

    func initTableView() {
        self.backgroundColor = .white
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.bounces = false
        self.delegate = self
        self.dataSource = self
//        answerUpdate()
//        content =  "以下不属于共同的论证评价标准的是()。以下不属于共同的论证评价标准的是()。"
//        options = ["逻辑标准", "修辞标准", "论辩标准", "分析标准"]
    }
    
    //闭包传值
//    @objc func answerUpdate() {
//        answerSelected = exerciseModel.answerSelected
//        if let answer = QuestionTableView.selectedAnswer {
//            optionsSelected = answerSelected!(answer, options.count)
//        }else {
//            return
//        }
//    }
    
    func loadQues(question: String, option: [String], isSelected: Bool, rightAnswer: String) {
        //请求数据
        content = question
        options = option
        selected = isSelected
        rightAns = rightAnswer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.delegate = nil
        print("QuestionTableView deinit")
    }

}

extension QuestionTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var isselect: Bool = false
        switch indexPath.item {
        case 0:
            let questionCell = QuestionCell()
            questionCell.initQCell(question: content)
            return questionCell
        case 1:
            return OptionsCell()
        default:
            let optionCell = OptionsCell()
            let optionIndex = indexPath.item - 2
            if let answer = QuestionTableView.selectedAnswer {
                if optionIndex == practiceModel.optionToIndexDic[answer] {
                    isselect = true
                }
            }
            optionCell.initUI(order: optionIndex, optionsContent: options[optionIndex], isSelected: isselect, rightAns: rightAns!)

            return optionCell
        }

    }
}

extension QuestionTableView: UITableViewDelegate {
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
    
    //点击选项
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selected == true {
            return
        }
        QuestionTableView.selectedAnswer = practiceModel.optionDics[indexPath.item]
//        answerUpdate()
        self.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "optionSelected"), object: nil)
    }
}
