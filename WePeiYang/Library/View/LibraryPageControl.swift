//
//  LibraryPageControl.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/10/27.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

class LibraryPageControl: UIPageControl {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        log("科科")
        let marginX = CGFloat(25)
        let newW = CGFloat(self.subviews.count) * marginX + 10
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: CGFloat(newW), height: self.frame.size.height)
        
        var center = self.center
        center.x = (self.superview?.center.x) ?? 0
        self.center = center
        for i in 0..<self.subviews.count {
            let dot = self.subviews[i]
            if i < self.currentPage {
                dot.frame = CGRect(x: CGFloat(i) * marginX, y: 4, width: 25, height: 25)
            } else if i == self.currentPage {
                dot.frame = CGRect(x: CGFloat(i) * marginX, y: -1, width: 35, height: 35)
            } else {
                dot.frame = CGRect(x: CGFloat(i - 1) * marginX + CGFloat(35), y: 4, width: 25, height: 25)
            }
        }
    }
}
