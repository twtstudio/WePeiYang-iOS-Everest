//
//  SearchView.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/23.
//  Modified by Halcao on 2017/7/18.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit

class SearchView: UIView {
    let backButton = ExtendedButton()
    let textField = UITextField()
    let backgroundView = UIView()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundView.frame = rect
        self.addSubview(backgroundView)
        backButton.setImage(UIImage(named: "ypback"), for: .normal)
        self.backgroundColor = UIColor(red: 0.1059, green: 0.6352, blue: 0.9019, alpha: 0.5)
        
        backgroundView.backgroundColor = UIColor(red: 0.1059, green: 0.6352, blue: 0.9019, alpha: 1)
        backButton.adjustsImageWhenHighlighted = false
        backgroundView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.centerY.equalToSuperview().offset(7)
            make.left.equalToSuperview().offset(20)
        }
        
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 0.074, green: 0.466, blue: 0.662, alpha: 1)
        backgroundView.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.height.equalTo(20)
            make.centerY.equalTo(self).offset(7)
            make.left.equalTo(backButton.snp.right).offset(10)
        }
        
        
        let iconView = UIImageView()
        iconView.image = UIImage(named: "search")
        backgroundView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.centerY.equalTo(self).offset(7)
            make.left.equalTo(separator.snp.right).offset(10)
        }
        
        let baseLine = UIView()
        baseLine.backgroundColor = UIColor.white
        backgroundView.addSubview(baseLine)
        baseLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(iconView.snp.bottom).offset(4)
            make.left.equalTo(iconView.snp.left)
            make.right.equalTo(backgroundView).offset(-15)
        }
        
        self.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(2)
            make.right.equalTo(baseLine.snp.right)
            make.bottom.equalTo(baseLine.snp.top).offset(-3)
            make.height.equalTo(20)
        }
        textField.clearButtonMode = .unlessEditing
        textField.textColor = .white
        textField.tintColor = .white
    }
    
    
}
