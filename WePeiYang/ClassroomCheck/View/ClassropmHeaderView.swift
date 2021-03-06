//
//  ClassropmHeaderView.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class ClassesHeaderView: UIView {
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        return label
    }()
    let noticeView1: NoticeView = {
        let view = NoticeView()
        return view
    }()
    let noticeView2: NoticeView = {
        let view = NoticeView()
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    func layout() {
        self.addSubview(timeLabel)
        self.addSubview(noticeView1)
        self.addSubview(noticeView2)

        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.height.equalTo(30)
        }
        
        
        noticeView2.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-18)
//            make.left.equalTo(noticeView1.snp.right).offset(5)
            make.height.equalTo(20)
            make.width.equalTo(70)
        }
        noticeView2.noticeLabel.text = "表示空闲"
        
        noticeView1.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(noticeView2.snp.left).offset(-5)
            make.width.equalTo(70)
            make.height.equalTo(20)
            
        }
        noticeView1.noticeLabel.text = "表示占用"
        noticeView1.noticeView.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64,alpha: 1)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

