//
//  FeedBackCard.swift
//  WePeiYang
//
//  Created by Zrzz on 2020/11/30.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class FeedBackCard: CardView {
//    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    
    override func initialize() {
        super.initialize()
        
        let padding: CGFloat = 0
//        titleLabel.text = "校务专区"
//        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.semibold)
//        titleLabel.textColor = .black
//        titleLabel.sizeToFit()
//
//        self.addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//            make.left.top.equalToSuperview().offset(padding)
//            make.width.equalTo(200)
//            make.height.equalTo(30)
//        }
//
        imageView.image = UIImage(named: "feedback_banner")
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
//            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.width.equalToSuperview().offset(-2 * padding)
            make.height.equalToSuperview().offset(-2 * padding)
            make.center.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-padding)
        }
        
        self.backgroundColor = UIColor(hex6: 0x3f54af)
        layout(rect: self.frame)
    }
    
    override func layout(rect: CGRect) {
        let padding: CGFloat = 20

        let layerWidth = rect.width - 2*padding
        let layerHeight = rect.height - 2*padding - 40

        blankView.frame = CGRect(x: padding, y: padding, width: layerWidth, height: layerHeight)

        super.layout(rect: rect)
    }
    
}
