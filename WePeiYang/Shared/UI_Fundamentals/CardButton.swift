//
//  CardButton.swift
//  WePeiYang
//
//  Created by Halcao on 2018/2/4.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class CardButton: UIButton {

    override var frame: CGRect {
        didSet{
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red:0.34, green:0.76, blue:0.97, alpha:1.00)
    }

    override func setTitle(_ title: String?, for state: UIControlState) {
        let attrString = NSAttributedString(string: title ?? "", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16, weight: UIFontWeightBlack), NSForegroundColorAttributeName: UIColor.white])
        setAttributedTitle(attrString, for: state)
        self.sizeToFit()
        self.width = CGFloat((title ?? "").count + 2)*10.0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.layer.bounds.height/2
        self.clipsToBounds = true
    }
}

