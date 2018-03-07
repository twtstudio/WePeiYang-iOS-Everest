//
//  UpLoadingPic.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/6.
//  Copyright © 2017年 twtstudio. All rights reserved.
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
                make.top.equalToSuperview().offset(0.1)
                make.left.equalToSuperview().offset(0.1)
                make.bottom.equalToSuperview().offset(-0.1)
                make.right.equalToSuperview().offset(-0.1)
                //                make.width.height.equalTo(contentView.bounds.width*(1/10))
                make.width.equalTo(40)
                make.height.equalTo(40)

            }
            
        }
    }
    // Initialization code
}


