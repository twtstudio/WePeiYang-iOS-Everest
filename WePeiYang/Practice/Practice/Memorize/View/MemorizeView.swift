//
//  MemorizeView.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/19.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation
import UIKit

class MemorizeView: UIView {
    
    let qScrollViewH: CGFloat = 0.8 * deviceHeight
    let qScrollViewW: CGFloat = deviceWidth
    let qH = 0.5 * deviceHeight
    let saperatorW = 0.9 * deviceWidth
    let view = UIView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: deviceHeight))
    
    let orderLabel = UILabel()

    var iscollected = false
    var currentPage: Int = 1
    
    var questions: [UIView] = []
    var answers: [UIView] = []
    static var numOfQ = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.addSubview(view)
        
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
        
        MemorizeView.numOfQ = questions.count
        
        setupQuestionsScrollView()
        setupButtons()
        setupSaperator()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtons() {
        let offset = 0.05 * deviceWidth
        let buttonsViewW = 0.35 * deviceWidth
        let buttonsViewH = 0.05 * deviceHeight
        
        let buttonsView = UIView()
        buttonsView.backgroundColor = .clear
        
        let collectBtn: UIButton = {
            let btn = UIButton()
            btn.setImage(#imageLiteral(resourceName: "collect"), for: .normal)
            return btn
        }()
        
        let showBtn: UIButton = {
            let btn = UIButton()
            btn.setImage(#imageLiteral(resourceName: "questions"), for: .normal)
            return btn
        }()
        
        collectBtn.addTarget(self, action: #selector(collect(_:)), for: .touchUpInside)
        
        
        let offsetY = 0.2 * deviceHeight
        let offsetX = 0.18 * deviceWidth
        let offsetm = 0.004 * deviceHeight
        
        view.addSubview(buttonsView)
        buttonsView.snp.makeConstraints { (make) in
            make.width.equalTo(buttonsViewW)
            make.height.equalTo(buttonsViewH)
            make.centerY.equalTo(view).offset(offsetY)
            make.centerX.equalTo(view).offset(offsetX)
        }
        
        buttonsView.addSubview(collectBtn)
        collectBtn.snp.makeConstraints { (make) in
            make.width.equalTo(buttonsViewH)
            make.height.equalTo(buttonsViewH)
            make.left.equalTo(buttonsView)
            make.top.equalTo(buttonsView).offset(offsetm)
        }
        
        buttonsView.addSubview(showBtn)
        showBtn.snp.makeConstraints { (make) in
            make.width.equalTo(buttonsViewH)
            make.height.equalTo(buttonsViewH)
            make.left.equalTo(buttonsView).offset(buttonsViewH + offset)
            make.top.equalTo(buttonsView)
        }
        
        orderLabel.text = "\(currentPage)/\(questions.count)"
        buttonsView.addSubview(orderLabel)
        orderLabel.snp.makeConstraints { (make) in
            make.width.equalTo(2 * buttonsViewH)
            make.height.equalTo(buttonsViewH)
            make.left.equalTo(buttonsView).offset((buttonsViewH + offset) * 2)
            make.top.equalTo(buttonsView)
        }
    }
    
    func setupSaperator() {
        let saperatorView = UIView()
        saperatorView.backgroundColor = UIColor(red: 177/255, green: 196/255, blue: 222/255, alpha: 1)
        view.addSubview(saperatorView)
        saperatorView.snp.makeConstraints { (make) in
            make.width.equalTo(saperatorW)
            make.height.equalTo(1)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(0.24 * deviceHeight)
        }
    }
    
    func setupQuestionsScrollView() {
        let qRect = CGRect(x: 0, y: 0, width: Int(qScrollViewW), height: Int(qScrollViewH))
        let qScrollView = QuestionsScrollView(frame: qRect)
        
        qScrollView.delegate = self
        qScrollView.creatScrollView(questionsView: questions, answersView: answers, wid: qScrollViewW, h: qScrollViewH, qvH: qScrollViewH * 0.6, avH: qScrollViewH * 0.3)
        
        view.addSubview(qScrollView)
        qScrollView.snp.makeConstraints { (make) in
            make.width.equalTo(qScrollViewW)
            make.height.equalTo(qScrollViewH)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(50)
        }
    }
    
    @objc func collect(_ button: UIButton) {
        if iscollected {
            button.setImage(#imageLiteral(resourceName: "collect"), for: .normal)
            iscollected = false
        }else {
            button.setImage(#imageLiteral(resourceName: "collected"), for: .normal)
            iscollected = true
        }
    }
}

extension MemorizeView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        currentPage = Int(pageNumber) + 1
        
        orderLabel.text = "\(currentPage)/\(MemorizeView.numOfQ)"
        print(currentPage)
        //        self.pageControl.currentPage = Int(pageNumber)
    }
}
