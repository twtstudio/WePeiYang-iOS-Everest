//
//  InfoView.swift
//  WePeiYang
//
//  Created by 安宇 on 2021/1/13.
//  Copyright © 2021 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class InfoView: UIView {
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.sizeToFit()
        label.textColor = .black
//        if deviceWidth == CGFloat.iPhoneSEWidth {
//            label.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.light)
//        } else {
//            label.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.light)
//        }
        return label
    }()
    let detailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.sizeToFit()
        label.textColor = .black
//        if deviceWidth == CGFloat.iPhoneSEWidth {
//            label.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.light)
//        } else {
//            label.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.light)
//        }
        return label
    }()
    let detailTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.sizeToFit()
        textField.textColor = .black
//        textField.placeholder = "请输入相应信息"
//        if deviceWidth == CGFloat.iPhoneSEWidth {
//            textField.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.light)
//        } else {
//            textField.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.light)
//        }
        return textField
    }()
    let sureButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        layout()
        // Total height: 40 + LabelHeight + 20 + smallLabelHeight + 40
    }
    
    
    func layout() {
       
        self.addSubview(infoLabel)
        self.addSubview(detailTextField)
        self.addSubview(detailLabel)
        
        self.addSubview(sureButton)
        infoLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-10)
            make.left.equalTo(10)
//            make.width.equalTo(50)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-10)
            make.left.equalTo(self.infoLabel.snp.right).offset(10)
            
        }
        
        sureButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(-10)
//            make.left.equalTo(self.detailTextField.snp.right).offset(10)
        }
        detailTextField.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-10)
            make.left.equalTo(self.detailLabel.snp.right).offset(5)
//            make.right.equalTo(sureButton.snp.left)
        }
        
        sureButton.setTitle("发送验证码", for: .normal)
        sureButton.titleLabel?.font =  UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        sureButton.isHidden = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

