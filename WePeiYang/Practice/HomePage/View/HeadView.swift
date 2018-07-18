//
//  HeadView.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/7/13.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class HeadView: UIView {
    
    /* 蓝色渐变背景 */
    let headBackgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: deviceHeight/4))
        
        /* 设置渐变 */
        let topColor = UIColor.init(hex6: 0x43AAFA, alpha: 1.0) // 深蓝
        let buttomColor = UIColor.init(hex6: 0x44C3EB, alpha: 1.0) // 天蓝
        let grandientColors = [topColor.cgColor, buttomColor.cgColor]
        
        let grandientLocations: [NSNumber] = [0.0, 1.0]
        let grandientLayer = CAGradientLayer()
        grandientLayer.colors = grandientColors
        grandientLayer.locations = grandientLocations
        
        grandientLayer.frame = view.frame
        view.layer.insertSublayer(grandientLayer, at: 0)
        
        /* 设置圆角 */
        view.corner(byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], radii: deviceWidth/8)
        
        return view
    }()
    
    /* 标题 */
    let headLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: deviceWidth/6, y: deviceHeight/18, width: deviceWidth/4, height: deviceHeight/24))
        
        label.text = "天外天刷题"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        
        return label
    }()
    
    /* 顶部按钮 (返回, 搜索) */
    static func addTopButton(withImage image: UIImage, andX x: CGFloat) -> UIButton {
        let topButton = UIButton(frame: CGRect(x: x, y: deviceHeight/18, width: deviceHeight/24, height: deviceHeight/24))
        
        topButton.setImage(image, for: .normal)
        
        return topButton
    }
    
    let topBackButton = addTopButton(withImage: #imageLiteral(resourceName: "practiceBack"), andX: deviceHeight/48)
    let topSearchButton = addTopButton(withImage: #imageLiteral(resourceName: "practiceSearch"), andX: deviceWidth-deviceHeight*(1/24 + 1/48))
    
    /* 切换按钮 (题库, 我的) */
    static func addOptionButton(withText text: String, andX x: CGFloat) -> UIButton {
        let optionButton = UIButton(frame: CGRect(x: x, y: deviceHeight/9, width: deviceWidth/10, height: deviceHeight/24))
        
        optionButton.setTitle(text, for: .normal)
        optionButton.setTitleColor(UIColor.white, for: .normal)
        
        return optionButton
    }
    
    let userOptionButton = addOptionButton(withText: "我的", andX: deviceWidth - deviceWidth * (1/10 + 1/4))
    let homeOptionButton = addOptionButton(withText: "题库", andX: deviceWidth/4)
    
    let underLine: UIView = {
        let view = UIView(frame: CGRect(x: deviceWidth * 3/5, y: deviceHeight * (1/9 + 1/24), width: deviceWidth/5, height: 2))
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        self.addSubview(headBackgroundView)
        self.addSubview(headLabel)
        
        self.addSubview(topBackButton)
        self.addSubview(topSearchButton)
        
        self.addSubview(userOptionButton)
        self.addSubview(homeOptionButton)
        userOptionButton.isEnabled = false
        self.addSubview(underLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIView {
    
    // 设置独立圆角
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
    }
    
}
