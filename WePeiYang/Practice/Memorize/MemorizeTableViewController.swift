//
//  MemorizeTableViewController.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/14.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class MemorizeViewController: UIViewController {
    let qScrollViewH: CGFloat = CGFloat(0.8 * deviceHeight)
    let qScrollViewW: CGFloat = CGFloat(deviceWidth)
    let qH = CGFloat(0.5 * deviceHeight)
    let saperatorW = 0.9 * deviceWidth
    let buttonsViewW = 0.35 * deviceWidth
    let buttonsViewH = 0.03 * deviceHeight

    
    var questions: [UIView] = []
    var answers: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        view.backgroundColor = .white
        self.view.addSubview(view)
        
        
        for i in 0..<4 {
            let tableView = UIView()
            
            if i % 2 == 0 {
                tableView.backgroundColor = .purple
            }else {
                tableView.backgroundColor = .black
            }

            questions.append(tableView)
        }
        
        for i in 0..<4 {
            let tableView = UIView()
            
            if i % 2 == 0 {
                tableView.backgroundColor = .black
            }else {
                tableView.backgroundColor = .purple
            }
            
            answers.append(tableView)
        }
        
        print(questions.count)
        
        setupQuestionsScrollView()
        
        setupButtons()
        
//        setupSaperator()
        
    }
    
    func setupButtons() {
        let buttonsView = UIView()
        buttonsView.backgroundColor = .blue
        
        let collectBut: UIButton = {
            let btn = UIButton()
            btn.backgroundColor = .purple
            return btn
        }()
        
        let offsetY = 0.2 * deviceHeight
        let offsetX = 0.25 * deviceWidth
        view.addSubview(buttonsView)
        buttonsView.snp.makeConstraints { (make) in
            make.width.equalTo(buttonsViewW)
            make.height.equalTo(buttonsViewH)
            make.centerY.equalTo(view).offset(offsetY)
            make.centerX.equalTo(view).offset(offsetX)
        }
        
//        view.addSubview(collectBut)
//        collectBut.snp.makeConstraints { (make) in
//            make.width.equalTo(50)
//            make.height.equalTo(50)
//            make.centerX.equalTo(view).offset(<#T##amount: ConstraintOffsetTarget##ConstraintOffsetTarget#>)
//        }
    }
    
//    func setupSaperator() {
//        let saperatorView = UIView()
//        saperatorView.backgroundColor = UIColor(red: 177/255, green: 196/255, blue: 222/255, alpha: 1)
//        view.addSubview(saperatorView)
//        saperatorView.snp.makeConstraints { (make) in
//            make.width.equalTo(saperatorW)
//            make.height.equalTo(1)
//            make.centerX.equalTo(view)
//            make.centerY.equalTo(view).offset(200)
//        }
//    }

    func setupQuestionsScrollView() {

        let qScrollView = QuestionsScrollView(frame: CGRect(x: 0, y: 0, width: Int(qScrollViewW), height: Int(qScrollViewH)))
    
        qScrollView.creatScrollView(questionsView: questions, answersView: answers, wid: qScrollViewW, h: qScrollViewH)
        
        view.addSubview(qScrollView)
        qScrollView.snp.makeConstraints { (make) in
            make.width.equalTo(qScrollViewW)
            make.height.equalTo(qScrollViewH)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(50)
        }
        
    }
}
