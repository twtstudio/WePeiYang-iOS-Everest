//
//  UpLoadingPicCell.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class UpLoadingPicCell: UITableViewCell {
    var addPictureImage = UIImageView()
    
    
    override var frame: CGRect{
        
        didSet{
            var newFrame = frame;
            
            newFrame.origin.x += 10;
            newFrame.origin.y += 5;
            newFrame.size.height += 35;
            newFrame.size.width = newFrame.size.height + 5;
            
            super.frame = newFrame;
            
            //            let addPictureImage = UIImageView()
            self.addSubview(addPictureImage)
            
            //            addPictureImage.image = UIImage(named: "发布图片")
            addPictureImage.snp.makeConstraints {
                make in
                make.top.equalToSuperview()
                make.left.equalToSuperview()
                make.bottom.equalToSuperview()
                make.right.equalToSuperview()
                //                make.width.height.equalTo(contentView.bounds.width*(1/10))
                //                make.width.equalTo(40)
                //                make.height.equalTo(40)
                
            }
            
        }
    }
    // Initialization code
}
