//
//  WPYUIColor.swift
//  WePeiYang
//
//  Created by uareagay on 2019/9/9.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import Foundation

func RGBCOLOR_HEX(_ h: Int) -> UIColor {
    return RGBACOLOR_HEX(h, 1)
}

func RGBACOLOR_HEX(_ h: Int, _ a: CGFloat) -> UIColor {
    return RGBACOLOR((((h)>>16)&0xFF), (((h)>>8)&0xFF), ((h)&0xFF), a)
}

func RGBACOLOR(_ r: Int, _ g: Int, _ b: Int) -> UIColor {
    return RGBACOLOR(r, g, b, 1)
}

func RGBACOLOR(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat) -> UIColor {
    return UIColor.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
}

func RGBPureColor(_ h: Int) -> UIColor {
    return RGBACOLOR(h, h, h)
}
