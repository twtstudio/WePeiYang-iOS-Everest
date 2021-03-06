//
//  QRCodeView.swift
//  WePeiYang
//
//  Created by 安宇 on 22/08/2019.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class QRCodeView: UIView {
    
    let scanView = UIImageView()
    let lineView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .white
        layout()
    }
    func layout() {
        self.addSubview(scanView)
        self.addSubview(lineView)
        
        scanView.snp.makeConstraints { (make) in
            make.centerX.equalTo(UIScreen.main.bounds.width / 2)
            make.centerY.equalTo(UIScreen.main.bounds.height / 2)
            make.left.equalTo(30)
            make.height.equalTo(self.scanView.snp.width)
        }
        scanView.image = UIImage(named: "92")
//        等设计图
        scanView.backgroundColor = .clear
        
        lineView.image = UIImage(named: "redBorder")
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
