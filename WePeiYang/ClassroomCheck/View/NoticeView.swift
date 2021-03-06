//
//  NoticeView.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class NoticeView: UIView {
    
    let noticeView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.layer.borderColor = UIColor(red: 0.42, green: 0.62, blue: 0.64,alpha: 1).cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        return view
    }()
    
    let noticeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    func layout() {
        self.addSubview(noticeView)
        self.addSubview(noticeLabel)
        
        noticeView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(0)
            make.height.equalTo(15)
            make.width.equalTo(15)
        }
        noticeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(noticeView.snp.top)
//            make.left.equalTo(noticeView.snp.right).offset(4)
            make.right.equalToSuperview()
            make.width.equalTo(55)
            make.height.equalTo(noticeView.snp.height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

