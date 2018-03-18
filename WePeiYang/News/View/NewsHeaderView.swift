//
//  NewsHeaderView.swift
//  WePeiYang
//
//  Created by Rick on 2018/2/5.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class NewsHeaderView: UIView {
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    let defaultFrame = CGRect(x: 0, y: 0, width: deviceWidth, height: 100)
    init(withTitle title: String) {
        super.init(frame: defaultFrame)
        titleLabel = UILabel(text: title, color: .black, fontSize: 35)
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.heavy)
        titleLabel.textAlignment = .left
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-10)
            make.height.equalTo(40)
            make.width.equalTo(240)
        }
        let now = Date()
        let formatter = DateFormatter(withFormat: "E MMMM d", locale: "en_US")
        dateLabel = UILabel(text: formatter.string(from: now), color: .black)
        dateLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(15)
            make.height.equalTo(22)
            make.width.equalTo(120)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 更改文字大小
    func viewScrolledByY(_ Y: CGFloat) {
        // scrollView开始滑动
        if Y <= -97 && Y > -130 {
            let fontSize: CGFloat =  -((16.0*Y) / 33.0) - 892.0/33.0
            self.titleLabel.font = UIFont.init(name: "HelveticaNeue-Bold", size: fontSize)
        }
        
        if Y <= -130 {
            self.titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 36.0)
        }
        
        if Y >= -97 {
            self.titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        }
    }
    
    func navigationBarHiddenScrollByY(_ Y: CGFloat) {
        self.titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 36)
        
    }
}
