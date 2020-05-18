//
//  ActivitiesView.swift
//  WePeiYang
//
//  Created by 安宇 on 20/08/2019.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class ActivitiesView: CardView {
    private let titleLabel = UILabel()
    
    
    override func initialize() {
        super.initialize()
        
        let padding: CGFloat = 20
        titleLabel.text = "活动"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.semibold)
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(padding)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        
    }
    
    override func layout(rect: CGRect) {
        let padding: CGFloat = 20
        
        let layerWidth = rect.width - 2*padding
        let layerHeight = rect.height - 2*padding - 40
        
        blankView.frame = CGRect(x: padding, y: padding + 30 + 15, width: layerWidth, height: layerHeight)
        
        super.layout(rect: rect)
    }
    
    func load() {
        self.setState(.empty("活动管理按这里", .lightGray))
    }
    
    override func refresh() {
        super.refresh()
        
        guard TwTUser.shared.token != nil else {
            self.setState(.failed("请先登录", .gray))
            return
        }
        
        setState(.loading("活动管理按这里", .gray))
        
        guard TwTUser.shared.token != nil else {
            return
        }
//        FIXME:下面是啥
//        ExamAssistant.loadCache(success: {
//            self.load()
//        }, failure: { err in
//            self.setState(.failed(err, .gray))
//        })
    }
}
