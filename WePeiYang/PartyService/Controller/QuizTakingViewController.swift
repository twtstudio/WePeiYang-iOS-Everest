//
//  QuizTakingViewController.swift
//  WePeiYang
//
//  Created by Allen X on 8/24/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//
import UIKit

class QuizTakingViewController: UIViewController {

    typealias Quiz = Courses.Study20.Quiz

    var courseID: String?
    var currentQuizIndex = 0
    //static var originalAnswer: [Int] = []
    //static var userAnswer: [Int] = []
    let bottomTabBar = UIView(color: .white)
    var bgView: UIView!
    var quizView: QuizView!

    let lastQuiz = UIButton(title: "上一题")
    let nextQuiz = UIButton(title: "下一题")
    let allQuizes = UIButton(title: "所有题目")

    var quizList: [Quiz?] = []

    override func viewWillAppear(_ animated: Bool) {

        self.view.frame.size.width = (UIApplication.shared.keyWindow?.frame.size.width)!

        //NavigationBar 的文字
        self.navigationController!.navigationBar.tintColor = UIColor.white

        //NavigationBar 的背景，使用了View
//        self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
        bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height))

        bgView.backgroundColor = .partyRed
        self.view.addSubview(bgView)

        //改变 statusBar 颜色
//        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        navigationController?.navigationBar.barStyle = .black

        let quizSubmitBtn = UIBarButtonItem(title: "交卷", style: UIBarButtonItemStyle.plain, target: self, action: #selector(QuizTakingViewController.submitAnswer))

        self.navigationItem.setRightBarButton(quizSubmitBtn, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        lastQuiz.titleLabel?.textColor = .white
        lastQuiz.layer.cornerRadius = 8
        lastQuiz.backgroundColor = .red
        lastQuiz.addTarget(QuizTakingViewController(), action: #selector(QuizTakingViewController.swipeToLastQuiz), for: .touchUpInside)

        nextQuiz.titleLabel?.textColor = .white
        nextQuiz.layer.cornerRadius = 8
        nextQuiz.backgroundColor = .red
        nextQuiz.addTarget(QuizTakingViewController(), action: #selector(QuizTakingViewController.swipeToNextQuiz), for: .touchUpInside)

        allQuizes.titleLabel?.textColor = .white
        allQuizes.layer.cornerRadius = 8
        allQuizes.backgroundColor = .red
        allQuizes.addTarget(QuizTakingViewController(), action: #selector(QuizTakingViewController.showAllQuizesList), for: .touchUpInside)

        quizView = QuizView(quiz: Courses.Study20.courseQuizes[currentQuizIndex]!, at: currentQuizIndex)

        computeLayout()

        let shadowPath = UIBezierPath(rect: bottomTabBar.bounds)
        bottomTabBar.layer.masksToBounds = false
        bottomTabBar.layer.shadowColor = UIColor.black.cgColor
        bottomTabBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        bottomTabBar.layer.shadowOpacity = 0.5
        bottomTabBar.layer.shadowPath = shadowPath.cgPath

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//SnapKit layout Computation
extension QuizTakingViewController {
    func computeLayout() {

        self.bottomTabBar.addSubview(lastQuiz)
        lastQuiz.snp.makeConstraints {
            make in
            make.left.equalTo(self.bottomTabBar).offset(10)
            make.centerY.equalTo(self.bottomTabBar)
            make.width.equalTo(88)
        }

        self.bottomTabBar.addSubview(nextQuiz)
        nextQuiz.snp.makeConstraints {
            make in
            make.right.equalTo(self.bottomTabBar).offset(-10)
            make.centerY.equalTo(self.bottomTabBar)
            make.width.equalTo(88)
        }

        self.bottomTabBar.addSubview(allQuizes)
        allQuizes.snp.makeConstraints {
            make in
            make.center.equalTo(self.bottomTabBar)
            make.width.equalTo(88)
        }

        self.view.addSubview(bottomTabBar)
        bottomTabBar.snp.makeConstraints {
            make in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.height.equalTo(60)
        }

        self.view.addSubview(quizView)
        quizView.snp.makeConstraints {
            make in
            make.top.equalTo(self.view).offset(self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.size.height + 18)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.bottomTabBar.snp.top)
        }
    }
}

extension QuizTakingViewController {
    convenience init(courseID: String) {
        self.init()
        self.courseID = courseID
    }

}

//Logic Func
extension QuizTakingViewController {
    @objc func submitAnswer() {

        //处理当前 quiz
        for fooView in self.view.subviews {
            if fooView.isKind(of: QuizView.self) {
                Courses.Study20.courseQuizes[fooView.tag]?.userAnswer = (fooView as! QuizView).calculateUserAnswerWeight()
                (fooView as! QuizView).saveChoiceStatus()
            }
        }

        let userAnswer = Courses.Study20.courseQuizes.compactMap { (quiz: Quiz?) -> Int? in
            guard let foo = quiz?.userAnswer else {
                SwiftMessages.showErrorMessage(body: "你还没有完成答题，不能交卷")
                return nil
            }
            return foo
        }

        let originalAnswer = Courses.Study20.courseQuizes.compactMap { (quiz: Quiz?) -> Int? in
            guard let foo = Int((quiz?.answer)!) else {
                SwiftMessages.showErrorMessage(body: "Oops!")
                return nil
            }
            return foo
        }

        guard originalAnswer.count == userAnswer.count else {
            return
        }

        Courses.Study20.submitAnswer(of: self.courseID!, originalAnswer: originalAnswer, userAnswer: userAnswer) {
            let finishBtn = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(QuizTakingViewController.finishQuizTaking))
            self.navigationItem.setRightBarButton(finishBtn, animated: true)

            let finishView = FinalView(status: Courses.Study20.finalStatusAfterSubmitting!, msg: Courses.Study20.finalMsgAfterSubmitting!)
            for fooView in self.view.subviews {
                if fooView.isKind(of: QuizView.self) || fooView.isEqual(self.bottomTabBar) {
                    fooView.removeFromSuperview()
                }
            }
            self.view.addSubview(finishView)
            finishView.snp.makeConstraints {
                make in
                make.top.equalTo(self.view).offset(self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.size.height + 18)
                make.left.equalTo(self.view)
                make.right.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
        }
    }

    @objc func swipeToNextQuiz() {
        self.currentQuizIndex += 1
        guard currentQuizIndex != Courses.Study20.courseQuizes.count else {
            SwiftMessages.showErrorMessage(body: "你已经在最后一道题啦")
            self.currentQuizIndex -= 1
            return
        }

        for fooView in self.view.subviews where fooView is QuizView {
            Courses.Study20.courseQuizes[fooView.tag]?.userAnswer = (fooView as! QuizView).calculateUserAnswerWeight()
            (fooView as? QuizView)?.saveChoiceStatus()
            fooView.removeFromSuperview()
        }

        quizView = QuizView(quiz: Courses.Study20.courseQuizes[currentQuizIndex]!, at: currentQuizIndex)

        self.view.addSubview(quizView)
        quizView.snp.makeConstraints {
            make in
            make.top.equalTo(self.view).offset(self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.size.height + 18)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.bottomTabBar.snp.top)
        }
    }

    @objc func swipeToLastQuiz() {
        self.currentQuizIndex -= 1
        guard currentQuizIndex >= 0 else {
            SwiftMessages.showErrorMessage(body: "你已经在第一题啦")
            self.currentQuizIndex += 1
            return
        }
        quizView = QuizView(quiz: Courses.Study20.courseQuizes[currentQuizIndex]!, at: currentQuizIndex)

        for fooView in self.view.subviews {
            if fooView.isKind(of: QuizView.self) {
                Courses.Study20.courseQuizes[fooView.tag]?.userAnswer = (fooView as! QuizView).calculateUserAnswerWeight()
                (fooView as! QuizView).saveChoiceStatus()
                fooView.removeFromSuperview()
            }
        }

        self.view.addSubview(quizView)
        quizView.snp.makeConstraints {
            make in
            make.top.equalTo(self.view).offset(self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.size.height + 18)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.bottomTabBar.snp.top)
        }
    }

    @objc func showAllQuizesList() {

        //Handle current quiz
        for fooView in self.view.subviews {
            if fooView.isKind(of: QuizView.self) {
                Courses.Study20.courseQuizes[fooView.tag]?.userAnswer = (fooView as! QuizView).calculateUserAnswerWeight()
                (fooView as! QuizView).saveChoiceStatus()
            }
        }

        let allVC = AllQuizViewController(quizList: Courses.Study20.courseQuizes)

        self.present(allVC, animated: true, completion: nil)
    }

    func showQuiz(at index: Int) {

        for fooView in self.view.subviews where fooView is QuizView {
            Courses.Study20.courseQuizes[fooView.tag]?.userAnswer = (fooView as! QuizView).calculateUserAnswerWeight()
            (fooView as! QuizView).saveChoiceStatus()
            fooView.removeFromSuperview()
        }

        self.currentQuizIndex = index

        quizView = QuizView(quiz: Courses.Study20.courseQuizes[currentQuizIndex]!, at: currentQuizIndex)

        self.view.addSubview(quizView)
        quizView.snp.makeConstraints {
            make in
            make.top.equalTo(self.view).offset(self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.size.height + 18)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.bottomTabBar.snp.top)
        }
    }

    @objc func finishQuizTaking() {
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

}
