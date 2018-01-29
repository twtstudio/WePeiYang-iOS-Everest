//
//  FinalView.swift
//  WePeiYang
//
//  Created by Allen X on 8/31/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class FinalView: UIView {

    var frownOrSmile: UIImageView!
    var finalMsgLabel: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
}


extension FinalView {
    convenience init(status: Int, msg: String) {
        
        self.init()
        
        if status == 1 || status == 0 {
            frownOrSmile = UIImageView(imageName: "frown", desiredSize: CGSize(width: 150, height: 150))
        } else if status == 2 {
            frownOrSmile = UIImageView(imageName: "smile", desiredSize: CGSize(width: 150, height: 150))
        }
        finalMsgLabel = UILabel(text: msg, color: UIColor(red: 149.0/255.0, green: 149.0/255.0, blue: 149.0/255.0, alpha: 1))
        finalMsgLabel.numberOfLines = 0
        
        self.addSubview(frownOrSmile)
        frownOrSmile.snp.makeConstraints {
            make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-20)
        }
        
        self.addSubview(finalMsgLabel)
        finalMsgLabel.snp.makeConstraints {
            make in
            make.top.equalTo(frownOrSmile.snp.bottom).offset(18)
            make.centerX.equalTo(self)
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
        }
    }
}
