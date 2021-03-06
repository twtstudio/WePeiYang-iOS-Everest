//
//  Color.swift
//
//
//  Created by 安宇 on 17/08/2019.
//

import Foundation

struct MyColor {
    static func ColorHex(_ color: String) -> UIColor? {
        if color.count <= 0 || color.count != 7 || color == "(null)" || color == "<null>" {
            return nil
        }
        var red: UInt32 = 0x0
        var green: UInt32 = 0x0
        var blue: UInt32 = 0x0
        let redString = String(color[color.index(color.startIndex, offsetBy: 1)...color.index(color.startIndex, offsetBy: 2)])
        let greenString = String(color[color.index(color.startIndex, offsetBy: 3)...color.index(color.startIndex, offsetBy: 4)])
        let blueString = String(color[color.index(color.startIndex, offsetBy: 5)...color.index(color.startIndex, offsetBy: 6)])
        Scanner(string: redString).scanHexInt32(&red)
        Scanner(string: greenString).scanHexInt32(&green)
        Scanner(string: blueString).scanHexInt32(&blue)
        let hexColor = UIColor.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
        return hexColor
    }
}
