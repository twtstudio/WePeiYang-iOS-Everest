//
//  PublishCustomCell.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/5.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class PublishCustomCell: UITableViewCell {
    
    
    var textField = UITextField()
    
    override var frame: CGRect{
        
        didSet{
            
            var newFrame = frame;
            
            newFrame.origin.x += 10;
            newFrame.size.width -= 20;
            newFrame.origin.y += 10;
//            newFrame.size.height -= 10;
            super.frame = newFrame;

//            textField.placeholder = "请输入";
            textField.adjustsFontSizeToFitWidth = true;  //当文字超出文本框宽度时，自动调整文字大小
            textField.minimumFontSize = 14;
            self.addSubview(textField);
            
            textField.snp.makeConstraints{
            
                make in
                make.top.equalToSuperview().offset(5)
                make.right.equalToSuperview().offset(-5)
            }
        }
        
        
        
    
    }


}
