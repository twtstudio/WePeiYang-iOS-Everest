//
//  PrivateCode.swift
//  WePeiYang
//
//  Created by 安宇 on 02/08/2019.
//  Copyright © 2019 twtstudio. All rights reserved.
//

import UIKit
import SnapKit
class QrCodeView: UIView {
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "这个人的头像")
        return imageView
    }()
    let name: UILabel = {
        let label = UILabel()
        //        MARK:要改
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.light)
        //        label.text = "账号名字"
        label.sizeToFit()
        label.textAlignment = .left
        return label
    }()
    let id: UILabel = {
        let label = UILabel()
        label.textColor = MyColor.ColorHex("#7E7E7E")
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.light)
        //        label.text = "3018000000"
        label.sizeToFit()
        label.textAlignment = .left
        return label
    }()
    let codeImage: UIImageView = {
        let imageView = UIImageView()
        //        imageView.image = UIImage(named: "生成的二维码")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        layout()
    }
    
    func layout() {
        self.addSubview(image)
        self.addSubview(name)
        self.addSubview(id)
        self.addSubview(codeImage)
        
        image.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(30)
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        name.snp.makeConstraints { (make) in
            make.left.equalTo(self.image.snp.right).offset(10)
            make.top.equalTo(self.image.snp.top).offset(5)
            make.height.equalTo(20)
            make.width.equalTo(180)
        }
        
        id.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.image.snp.bottom).offset(-5)
            make.left.equalTo(self.name.snp.left)
            make.height.equalTo(15)
            make.width.equalTo(180)
        }
        //        MARK:codeImage的frame在使用的时候单独设
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

