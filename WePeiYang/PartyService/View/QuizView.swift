//
//  QuizView.swift
//  WePeiYang
//
//  Created by Allen X on 8/25/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class QuizView: UIView {

    typealias Quiz = Courses.Study20.Quiz

    var quizDescLabel = UILabel()
    //题目总加权
    var userSelectedWeight = 0
    var originalAnswerWeight = 0
    var hasMultipleChoices = false

    var optionButtons: [Checkbox]!
    var optionLabels: [UILabel]!

    @objc func didSelectOptionButton(_ button: Checkbox) {

        if !hasMultipleChoices {
            for foo in optionButtons where foo != button && foo.wasChosen {
                foo.wasChosen = false
                foo.refreshStatus()
            }
        }
    }

    func saveChoiceStatus() {
        var fooArr: [Int] = []
        log.word("fuckers")/
        for i in 0..<optionButtons.count where optionButtons[i].wasChosen {
            log.word("entered if")/
            //                log.any(Courses.Study20.courseQuizes[self.tag]?.options[i].weight)/
            fooArr.append(i)
            //                    log.word("\(i)")/
        }
        if fooArr != [] {
            Courses.Study20.courseQuizes[self.tag]?.chosenOnesIndexes = fooArr
            log.any(fooArr)/
//            log.any(Courses.Study20.courseQuizes[self.tag]?.chosenOnesIndexes)/
        }
    }

    func calculateUserAnswerWeight() -> Int? {
        for foo in optionButtons where foo.wasChosen {
            userSelectedWeight += foo.tag
        }

        if userSelectedWeight != 0 {
            return userSelectedWeight
        }
        return nil
    }

}

extension QuizView {
    convenience init(quiz: Quiz, at index: Int) {

        self.init()
        self.tag = index

        if quiz.type == "0" {
            self.hasMultipleChoices = false
        } else {
            self.hasMultipleChoices = true
        }

        if hasMultipleChoices {
            optionButtons = Checkbox.initMultiChoicesBtns(with: quiz.options)
        } else {
            optionButtons = Checkbox.initOnlyChoiceBtns(with: quiz.options)
        }
        for btn in optionButtons {
            btn.addTarget(self, action: #selector(QuizView.didSelectOptionButton(_:)), for: .touchUpInside)
        }

        if let chosenOnesIndices = Courses.Study20.courseQuizes[self.tag]?.chosenOnesIndexes {
            for index in chosenOnesIndices {
                optionButtons[index].backgroundColor = .green
                optionButtons[index].wasChosen = true
            }
        }

        optionLabels = UILabel.initWithQuiz(quiz)

        /*
        for i in 0..<optionLabels.count {
            let tapOnLabel = UITapGestureRecognizer(target: optionButtons[i], action: #selector())
        }*/

        quizDescLabel = {
            let foo = UILabel(text: "\(self.tag + 1). " + quiz.content, fontSize: 20)
            foo.numberOfLines = 0
            return foo
        }()

        self.originalAnswerWeight = Int(quiz.answer)!

        self.addSubview(quizDescLabel)
        quizDescLabel.snp.makeConstraints {
            make in
            make.top.equalTo(self).offset(20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }

        self.addSubview(optionButtons[0])
        optionButtons[0].snp.makeConstraints {
            make in
            make.top.equalTo(quizDescLabel.snp.bottom).offset(16)
            make.left.equalTo(quizDescLabel)
            make.width.height.equalTo(20)
        }
        self.addSubview(optionLabels[0])
        optionLabels[0].snp.makeConstraints {
            make in
            make.top.equalTo(optionButtons[0])
            make.left.equalTo(optionButtons[0].snp.right).offset(8)
            make.right.equalTo(self).offset(-20)
        }

        for i in 1..<optionButtons.count {
            self.addSubview(optionButtons[i])
            self.addSubview(optionLabels[i])
            optionButtons[i].snp.makeConstraints {
                make in
                if optionLabels[i-1].frame.origin.y+optionLabels[i-1].frame.size.height > optionButtons[i-1].frame.origin.y+optionButtons[i-1].frame.size.height {
                    make.top.equalTo(optionLabels[i-1].snp.bottom).offset(4)
                } else {
                    make.top.equalTo(optionButtons[i-1].snp.bottom).offset(4)
                }
                make.left.equalTo(optionButtons[i-1])
                make.right.equalTo(optionButtons[i-1])
                make.height.equalTo(optionButtons[i-1])
            }
            optionLabels[i].snp.makeConstraints {
                make in
                make.top.equalTo(optionButtons[i])
                make.left.equalTo(optionButtons[i].snp.right).offset(8)
                make.right.equalTo(self).offset(-20)
            }
        }
    }
}

private extension UILabel {
    typealias Quiz = Courses.Study20.Quiz
    static func initWithQuiz(_ quiz: Quiz) -> [UILabel] {
        return quiz.options.flatMap({ (option: Quiz.Option) -> UILabel? in
            let foo = UILabel(text: option.name, color: .black)
            foo.numberOfLines = 0
            foo.isUserInteractionEnabled = true
            return foo
        })
    }
}
