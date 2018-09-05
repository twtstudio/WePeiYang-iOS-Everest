//
//  BicycleCard.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/9/4.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class BicycleCard: CardView {
    
    let padding: CGFloat = 20
    
    let titleLabel = UILabel()
    
    let balanceLabel = UILabel()
    
    let lastRecordLabel = UILabel()
    
    override func initialize() {
        super.initialize()
        // Bicycle Green (Refer to Bicycle Module)
        // self.backgroundColor = UIColor(red: 39.0/255.0, green: 174.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        // Spring Green (Refer to http://www.sioe.cn/yingyong/yanse-rgb-16/)
        // self.backgroundColor = UIColor(red: 60.0/255.0, green: 179.0/255.0, blue: 113.0/255.0, alpha: 1.0)
        // Dark Gray (Refer to discussion)
        self.backgroundColor = .darkGray

        titleLabel.text = "自行车"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.semibold)
        titleLabel.sizeToFit()
        titleLabel.frame.origin = CGPoint(x: padding, y: padding)
        self.addSubview(titleLabel)
        
        balanceLabel.text = "余额：暂无数据"
        balanceLabel.textColor = .white
        
        lastRecordLabel.text = "最近记录：暂无数据"
        lastRecordLabel.textColor = .white
        
        loadBicycle()
    }
    
    override func refresh() {
        super.refresh()
        
        guard TwTUser.shared.bicycleBindingState else {
            self.setState(.failed("请绑定自行车", .white))
            return
        }
        
        loadBicycle()
    }
    
    func loadBicycle() {
        if let balance = BicycleUser.sharedInstance.balance { balanceLabel.text = "余额：¥\(balance)" }
        
        balanceLabel.sizeToFit()
        balanceLabel.frame.origin = CGPoint(x: padding, y: 140)
        self.addSubview(balanceLabel)
        
        // Simplifed, details refer to BicycleServiceInfoController and BicyleUser with BicycleAPI
        if let record = BicycleUser.sharedInstance.record {
            let timeStampString = (record["arr_time"] as! Int == 0 ? record["dep_time"] : record["arr_time"]) as! String
            lastRecordLabel.text = "最近记录：" + (record["arr_time"] as! Int == 0 ? "借车" : "还车") + " - \(timeStampTransfer.stringFromTimeStampWithFormat(format: "yyyy-MM-dd HH:mm", timeStampString: timeStampString))"
        }
        
        lastRecordLabel.sizeToFit()
        lastRecordLabel.frame.origin = CGPoint(x: padding, y: 180)
        self.addSubview(lastRecordLabel)
    }
    
}
