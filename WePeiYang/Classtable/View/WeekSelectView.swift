//
//  WeekSelectView.swift
//  WePeiYang
//
//  Created by Halcao on 2018/1/22.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class WeekSelectView: UIScrollView {
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor(red: 0.89, green: 0.97, blue: 0.96, alpha: 1.00)
        initialized()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialized() {
        self.showsHorizontalScrollIndicator = false

        let width = 50 as CGFloat
        let height = 60 as CGFloat
        self.contentSize = CGSize(width: width*22, height: height)

        for i in 0..<22 {
            let cell = WeekItemCell(frame: CGRect(x: width*CGFloat(i), y: 0, width: width, height: height))
            cell.isUserInteractionEnabled = true
            cell.tag = i + 1
            self.addSubview(cell)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        super.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !self.isDragging {
            self.next?.touchesEnded(touches, with: event)
        }
        super.touchesEnded(touches, with: event)
    }

    override func touchesShouldCancel(in view: UIView) -> Bool {
        return view is WeekItemCell
    }

    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        return view is WeekItemCell
    }
}
