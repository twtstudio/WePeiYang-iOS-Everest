//
//  Extension.swift
//  WePeiYang
//
//  Created by yuting jiang on 2018/7/21.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /// calculate the height of the text with constrainted width
    ///
    /// - Parameters:
    ///   - width: Label constrained width
    ///   - font: font of Label text
    /// - Returns: height of the text
    func calculateHeightWithConstrained(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
}
