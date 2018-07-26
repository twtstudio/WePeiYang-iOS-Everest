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
    var questionView = QuestionTableView(frame: .zero, style: .grouped)
    var testView = AnswerScrollView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        questionView.backgroundColor = .white
        self.addSubview(questionView)
        
        //
        testView.backgroundColor = .white
        self.addSubview(testView)
    }
    
    func initExerciseCell() {
        let offsety = 0.15 * deviceHeight
        questionView.snp.makeConstraints { (make) in
            make.width.equalTo(QuestionViewParameters.questionViewW)
            make.height.equalTo(QuestionViewParameters.questionViewH)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-offsety)
        }
    }
    
    func addAnswerView(result: String?, answer: String?) {
        testView.backgroundColor = .purple
        testView.creatAnswerView(result: result, answer: answer)
        
        self.addSubview(testView)
        testView.snp.makeConstraints { (make) in
            make.width.equalTo(QuestionViewParameters.questionViewW)
            make.height.equalTo(AnswerViewParameters.answerViewH)
            make.centerX.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
