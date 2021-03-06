//
//  SecondCell.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class Test2CollectionViewCell: UICollectionViewCell {
    
    
    let tagLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        return l
    }()
    let label: UILabel = {
        let l = UILabel()
        l.text = "test"
        l.textAlignment = .center
        l.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)
        return l
    }()
    let sizeLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        l.textColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 0.75)
        return l
    }()
    let backgroundV: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.42, green: 0.62, blue: 0.64, alpha: 1)

        return view
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.addSubview(backgroundV)
        self.contentView.addSubview(sizeLabel)
        self.contentView.addSubview(label)
        
        

        label.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        backgroundV.snp.makeConstraints { (make) in
            make.centerX.equalTo(label.snp.centerX)
            make.centerY.equalTo(label.snp.centerY)
            make.width.equalTo(24)
            make.height.equalTo(backgroundV.snp.width)
        }
        backgroundV.isHidden = true
        backgroundV.layer.cornerRadius = 6
        sizeLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-7)
            make.right.equalToSuperview().offset(-7)
            make.width.equalTo(6)
            make.height.equalTo(6)
        }
        

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

