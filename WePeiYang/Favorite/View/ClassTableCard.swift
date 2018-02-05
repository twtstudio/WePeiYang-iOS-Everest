//
//  ClassTableCard.swift
//  WePeiYang
//
//  Created by Halcao on 2018/1/27.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class ClassTableCard: CardView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    var cells: [CourseCell] = []
    
    override func initialize() {
        super.initialize()
        let padding: CGFloat = 20
        
        titleLabel.frame = CGRect(x: padding, y: padding, width: 200, height: 20)
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        titleLabel.textColor = UIColor(red:0.41, green:0.41, blue:0.41, alpha:1.00)
        titleLabel.sizeToFit()
        self.addSubview(titleLabel)

        subtitleLabel.frame = CGRect(x: padding, y: padding + 20, width: 200, height: 30)
        // TODO: 明天的课程
        subtitleLabel.text = "今天的课程"
        subtitleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFontWeightSemibold)
        subtitleLabel.textColor = .black
        subtitleLabel.sizeToFit()
        self.addSubview(subtitleLabel)
        
        self.backgroundColor = .white
        
        layout(rect: self.frame)
    }
    
    override func layout(rect: CGRect) {
        let padding: CGFloat = 20
        let offset: CGFloat = 2
        let cellWidth = (rect.width - 2*padding - 4*offset) / 5 as CGFloat
        let cellHeight = 110 as CGFloat
        if cells.count == 0 {
            // 初始化
            for i in 0..<5 {
                let cell = CourseCell(style: .default, reuseIdentifier: "CourseCell\(i.description)")
                cell.frame = CGRect(x: padding+(cellWidth+offset)*CGFloat(i), y: 95, width: cellWidth, height: cellHeight)
                cell.tag = i
                cells.append(cell)
                self.addSubview(cell)
            }
        } else {
            // 调整位置
            for i in 0..<5 {
                let cell = cells[i]
                cell.frame = CGRect(x: padding+(cellWidth+offset)*CGFloat(i), y: 95, width: cellWidth, height: cellHeight)
            }
        }
    }
}
