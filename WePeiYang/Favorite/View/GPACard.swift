//
//  GPACard.swift
//  GPACard
//
//  Created by Halcao on 2017/12/6.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class GPACard: CardView {
    let titleLabel = UILabel()
    let bezierLayer = BezierLineLayer(points: [])
    
    override func initialize() {
        super.initialize()
        let padding: CGFloat = 20
        
        titleLabel.frame = CGRect(x: padding, y: padding, width: 200, height: 30)
        titleLabel.text = "我的 GPA"
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightSemibold)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)
        
        self.backgroundColor = UIColor(red:0.98, green:0.66, blue:0.61, alpha:1.00)
        
    }
    
    func drawLine(points: [CGPoint]) {
        bezierLayer.points = points
        //        self.layer.sublayers?.removeAll()
    }
    
    override func layout(rect: CGRect) {
        let padding: CGFloat = 20
        
        let layerWidth = rect.width - 2*padding
        let layerHeight = rect.height - 2*padding - 30
        bezierLayer.frame = CGRect(x: padding, y: padding + 30 + 20, width: layerWidth, height: layerHeight)
        //        bezierLayer.points = points
        self.layer.addSublayer(bezierLayer)
    }
    
}
