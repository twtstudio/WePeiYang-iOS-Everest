//
//  PTQuestionTableView.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

/// 题目及选项TableView父类
class PTQuestionTableView: UITableView {
    let practiceModel = PracticeModel()
    let exerciseModel = PTExerciseModel()
    let questionViewParameters = PTQuestionViewParameters()
    
    static var selectedAnswer: String?
    var content: String?                   //题目字符串
    var options: [String?] = []            //各选项字符串数组
    var selected: Bool = false             //是否已做过
    var usrAnswer: String?                 //单选用户答案
    var rightAns: String?                  //单选正确答案
    var quesType: Int?                     //题目类型（单选、多选、判断）
    var practiceMode: PracticeMode?        //练习模式
    
    //多选题用户答案
    static var selectedAnswerArray: [Bool] = {
        return []
    }()
    //多选题正确答案
    var rightAnswers: [Bool] = {
        return []
    }()
    
    var answerSelected: ((String, Int) -> ([Bool]))?
    
    /// 判断选择是否正确。Int为选项顺序，String为正确答案。
    var answerResult: ((Int, String) -> Bool)?
    
//    let exerciseController = ExerciseCollectionViewController()
  
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
        self.contentOffset.y = 0
        
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PTQuestionTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
        case 0:
            if let question = content {
                //cell自适应高度
                let height = question.calculateHeightWithConstrained(width: frame.width , font: questionViewParameters.qFont) < questionViewParameters.minCellH ? questionViewParameters.minCellH : question.calculateHeightWithConstrained(width: frame.width, font: questionViewParameters.qFont)
                return height
            } else {
                //cell最小高度
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

extension PTQuestionTableView {
    func addScrollHint() {
        let scrollHint = UIImageView(image: #imageLiteral(resourceName: "error"))
        self.backgroundView = UIView()
        self.backgroundView!.addSubview(scrollHint)
        scrollHint.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.bottom.centerX.equalTo(self)
        }
    }
}
