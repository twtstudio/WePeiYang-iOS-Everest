//
//  UserView.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/7/13.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class UserView: UIView {
    
    static func addCell(withImage image: UIImage, andText text: String, andY y: CGFloat) -> UIButton {
        
        let button = UIButton(frame: CGRect(x: deviceHeight/48, y: y, width: deviceWidth - deviceHeight/24, height: deviceHeight/12))
        button.setImage(image, for: .normal)
        button.setTitle(text, for: .normal)
        
        return button
    }
    
    // let practiceStatistics = addCell(withImage: #imageLiteral(resourceName: "顺序练习"), andText: "练习统计", andY: deviceHeight/2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        // self.addSubview(practiceStatistics)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
