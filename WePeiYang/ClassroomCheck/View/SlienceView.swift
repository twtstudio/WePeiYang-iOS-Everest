//
//  SlienceView.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class SlienceView: UIView {
    
    let button1: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return button
    }()
    
    let button2: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return button
    }()
    private lazy var scrollLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 0.5)
        return line
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2
        self.backgroundColor = .white
//        self.backgroundColor = .red
        layout()
        
    }
    
    func layout() {
        
        self.addSubview(button1)
        self.addSubview(button2)
        self.addSubview(scrollLine)
        
        button1.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(6)
//            make.left.equalTo(5)
            make.height.equalTo(30)
        }
        
        button2.snp.makeConstraints { (make) in
            make.top.equalTo(self.button1.snp.bottom).offset(5)
//            make.left.equalTo(self.button1.snp.left)
            make.centerX.equalToSuperview()
            make.height.equalTo(self.button1.snp.height)
            make.width.equalTo(self.button1.snp.width)
        }
        
        scrollLine.snp.makeConstraints { (make) in
            make.top.equalTo(self.button1.snp.bottom).offset(2)
            make.left.equalTo(self.button1.snp.left)
            make.height.equalTo(0.3)
            make.width.equalTo(self.button1.snp.width)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
