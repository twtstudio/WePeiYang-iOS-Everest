//
//  UniversalExtension.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/13.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

extension String {
    var sha1: String {
        get {
            let data = self.data(using: String.Encoding.utf8)!
            var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
            data.withUnsafeBytes {
                _ = CC_SHA1($0, CC_LONG(data.count), &digest)
            }
            let hexBytes = digest.map { String(format: "%02hhx", $0) }
            return hexBytes.joined()
        }
    }
}

extension UIFont {
    //    #define kScreenWidthRatio  (UIScreen.mainScreen.bounds.size.width / 375.0)
    //    #define kScreenHeightRatio (UIScreen.mainScreen.bounds.size.height / 667.0)
    //    #define AdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)
    static func flexibleSystemFont(ofSize size: CGFloat) -> UIFont {
        var size = size
        if UIDevice.current.model != "iPad" {
            size = (UIScreen.main.bounds.size.width / 375.0) * size
        }
        return UIFont.systemFont(ofSize: size)
    }

    static func flexibleSystemFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        var size = size
        if UIDevice.current.model != "iPad" {
            size = (UIScreen.main.bounds.size.width / 375.0) * size
        }
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
}

