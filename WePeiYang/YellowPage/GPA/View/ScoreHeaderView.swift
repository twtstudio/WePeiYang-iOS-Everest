//
//  ScoreHeaderView.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/14.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class ScoreHeaderView: UIView {
    let totalScoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 27, weight: UIFont.Weight.light)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    let totalGPALabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 27, weight: UIFont.Weight.light)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    let totalCreditLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 27, weight: UIFont.Weight.light)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        layout()
        // Total height: 40 + LabelHeight + 20 + smallLabelHeight + 40
    }
    
    func layout() {
        // constants
        let topPadding: CGFloat = 20
        let baseWidth: CGFloat = UIScreen.main.bounds.width/4
        //        let bottomPadding = topPadding
        let labelPadding: CGFloat = 5
        
        totalScoreLabel.width = baseWidth
        totalGPALabel.width = baseWidth
        totalCreditLabel.width = baseWidth
        
        totalScoreLabel.height = 35
        totalGPALabel.height = 35
        totalCreditLabel.height = 35
        
        totalScoreLabel.center.x = baseWidth*1
        totalGPALabel.center.x = baseWidth*2
        totalCreditLabel.center.x = baseWidth*3
        
        totalScoreLabel.y = topPadding
        totalGPALabel.y = topPadding
        totalCreditLabel.y = topPadding
        
        totalScoreLabel.text = "不"
        totalGPALabel.text = "知"
        totalCreditLabel.text = "道"


        self.addSubview(totalScoreLabel)
        self.addSubview(totalGPALabel)
        self.addSubview(totalCreditLabel)
        
        // color
        let scoreHintLabel = UILabel(text: "总加权", color: UIColor(red:0.28, green:0.28, blue:0.28, alpha:1.00))
        scoreHintLabel.textAlignment = .center
        scoreHintLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        
        let GPAHintLabel = UILabel(text: "总绩点", color: UIColor(red:0.28, green:0.28, blue:0.28, alpha:1.00))
        GPAHintLabel.textAlignment = .center
        GPAHintLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        
        let creditHintLabel = UILabel(text: "总学分", color: UIColor(red:0.28, green:0.28, blue:0.28, alpha:1.00))
        creditHintLabel.textAlignment = .center
        creditHintLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        
        self.addSubview(scoreHintLabel)
        self.addSubview(GPAHintLabel)
        self.addSubview(creditHintLabel)
        
        scoreHintLabel.center.x = baseWidth*1
        GPAHintLabel.center.x = baseWidth*2
        creditHintLabel.center.x = baseWidth*3
        
        scoreHintLabel.y = totalScoreLabel.y + totalScoreLabel.height + labelPadding
        GPAHintLabel.y = scoreHintLabel.y
        creditHintLabel.y = scoreHintLabel.y
        
        let separator = UIView()
        self.addSubview(separator)
        separator.height = 1
        separator.width = 3*baseWidth
        separator.x = baseWidth/2
        separator.y = scoreHintLabel.y + scoreHintLabel.height + 30
        separator.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.00)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
