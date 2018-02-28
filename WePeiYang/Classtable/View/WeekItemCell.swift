//
//  WeekItemCell.swift
//  WePeiYang
//
//  Created by Halcao on 2018/1/22.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class WeekItemCell: UIView {
    var weekLabel = UILabel()
    var matrix: [[Bool]] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        weekLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 20)
        self.addSubview(weekLabel)
        self.layer.cornerRadius = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(courses: [[Bool]], week: Int) {
        matrix = courses
        let attrString = NSMutableAttributedString(string: "第\(week)周")
        attrString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 9)], range: NSRange(location: 0, length: 1))
        let length = week > 9 ? 2 : 1
        attrString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], range: NSRange(location: 1, length: length))
        attrString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 9)], range: NSRange(location: 1 + length, length: 1))
        attrString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor(red:0.27, green:0.39, blue:0.49, alpha:1.00)], range: NSRange(location: 0, length: 2 + length))
        weekLabel.attributedText = attrString
        weekLabel.sizeToFit()
        weekLabel.x = (self.width - weekLabel.width)/2
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        let radius = 4.8 as CGFloat
        let offset = 1 as CGFloat
        let padding = (rect.width - CGFloat(matrix.count)*(radius + offset))/2
        
        for i in 0..<matrix.count {
            let line = matrix[i]
            for j in 0..<line.count {
                let ellipseRect = CGRect(x: padding+CGFloat(j)*(radius + offset), y: weekLabel.height+CGFloat(i)*(radius + offset), width: radius, height: radius)
                let color = line[j] ? UIColor(red:0.17, green:0.86, blue:0.83, alpha:1.00).cgColor : UIColor(red:0.81, green:0.85, blue:0.85, alpha:1.00).cgColor
                ctx.setFillColor(color)
                ctx.addEllipse(in: ellipseRect)
                ctx.fillEllipse(in: ellipseRect)
            }
        }
    }
    
    func setSelected() {
        self.backgroundColor = .white
    }
    
    func dismissSelected() {
        self.backgroundColor = .clear
    }
}
