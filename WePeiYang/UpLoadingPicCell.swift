//
//  UpLoadingPic.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/6.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class UpLoadingPicCell: UITableViewCell {
    
    
    override var frame: CGRect{
        
        didSet{
            var newFrame = frame;
            
            newFrame.origin.x += 10;
            newFrame.origin.y += 5;
            newFrame.size.height += 35;
            newFrame.size.width = newFrame.size.height + 5;

            super.frame = newFrame;
        }
        // Initialization code
    }
    
}
