//
//  ExtendedButton.swift
//  TJUBBS
//
//  Created by Halcao on 2017/7/8.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class ExtendedButton: UIButton {
    var extendedWidth: CGFloat = 44
    var extendedHeight: CGFloat = 44

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let bounds = self.bounds
        let widthDelta = max(extendedWidth - bounds.size.width, 0)
        let heightDelta = max(extendedHeight - bounds.size.height, 0)
        //注意这里是负数，扩大了之前的bounds的范围
        let newBounds = bounds.insetBy(dx: -0.5*widthDelta, dy: -0.5*heightDelta)
        return newBounds.contains(point)
    }

}
