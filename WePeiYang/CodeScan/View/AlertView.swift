//
//  AlertView.swift
//
//
//  Created by 安宇 on 04/08/2019.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class AlertView: UIView {
    
    let prefix: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        textField.textColor = MyColor.ColorHex("#3C3C3C")
        textField.textAlignment = .left
        return textField
    }()
    let id: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        textField.textColor = MyColor.ColorHex("#3C3C3C")
        return textField
    }()
    let name: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        
        textField.textColor = MyColor.ColorHex("#3C3C3C")
        return textField
    }()
    let question: UITextField = {
        let textField = UITextField()
//        textField.te
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        textField.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        textField.textColor = MyColor.ColorHex("#3C3C3C")
        return textField
    }()
    let okButton: UIButton = {
        let button = UIButton()
//        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(MyColor.ColorHex("#EDA2BC"), for: .normal)
        return button
    }()
    let cancelButton: UIButton = {
        let button = UIButton()
//        button.backgroundColor = .white
        //这样字体就不用设了吧，SimHei
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(MyColor.ColorHex("#EDA2BC"), for: .normal)

        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        layout()
    }
    
    func layout() {
        
        self.addSubview(prefix)
        self.addSubview(id)
        self.addSubview(name)
        self.addSubview(question)
        self.addSubview(okButton)
        self.addSubview(cancelButton)
        
        prefix.snp.makeConstraints { (make) in
            make.top.equalTo(35)
            make.left.equalTo(30)
            make.width.equalTo(250)
            make.height.equalTo(20)
        }
        prefix.text = "录入信息为"
        
        id.snp.makeConstraints { (make) in
            make.left.equalTo(self.prefix.snp.left)
            make.top.equalTo(self.prefix.snp.bottom).offset(20)
            make.width.equalTo(120)
            make.height.equalTo(self.prefix.snp.height)
        }
//        id.text = "3018888888"
        
        name.snp.makeConstraints { (make) in
            make.left.equalTo(self.id.snp.right).offset(10)
            make.top.equalTo(self.id.snp.top)
            make.width.equalTo(50)
            make.height.equalTo(self.id.snp.height)
        }
//        name.text = "123"
        
        question.snp.makeConstraints { (make) in
            make.left.equalTo(self.prefix.snp.left)
            make.top.equalTo(self.id.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(self.prefix.snp.height)
        }
        question.text = "是否录入?"
        
        okButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.question.snp.bottom).offset(15)
            make.left.equalTo(150)
            make.width.equalTo(40)
            make.height.equalTo(25)
        }
        okButton.setTitle("确认", for: .normal)


        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.okButton.snp.top)
            make.left.equalTo(self.okButton.snp.right).offset(10)
            make.width.equalTo(self.okButton.snp.width)
            make.height.equalTo(self.okButton.snp.height)
        }

        cancelButton.setTitle("取消", for: .normal)
        
       
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
