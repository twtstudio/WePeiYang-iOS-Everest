//
//  DiningHallCollectionViewCell.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/3/16.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class DiningHallCollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var view: UIView!
    var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let viewWidth: CGFloat = 60
        let textWidth: CGFloat = 35
        let edgeWidth: CGFloat = (viewWidth - textWidth)/2
        
        view = UIView(frame: CGRect(x: (self.width-viewWidth)/2, y: 0, width: viewWidth, height: viewWidth))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30
        
        //设置渐变色
        gradientLayer = CAGradientLayer()
        //gradientLayer.frame = view.frame
        //会烂
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [Metadata.Color.foodReviewsLowColor.cgColor, Metadata.Color.foodReviewsHighColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        
        imageView = UIImageView(frame: CGRect(x: edgeWidth, y: edgeWidth, width: textWidth, height: textWidth))
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: viewWidth+8, width: self.width, height: 20))
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        
        view.addSubview(imageView)
        self.addSubview(view)
        self.addSubview(titleLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
