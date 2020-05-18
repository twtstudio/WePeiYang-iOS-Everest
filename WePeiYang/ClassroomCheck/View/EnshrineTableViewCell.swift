//
//  TableViewCell.swift
//  WePeiYang
//
//  Created by 安宇 on 2020/3/23.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class EnshrineTableViewCell: UITableViewCell {
    
    let circleView: UIView = {
        let view = UIView()
//        view.layer.cornerRadius = 20
//        圆形学到了
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        
        return view
    }()
    let locLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    let idLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "收藏")
        return imageView
    }()
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.86, green: 0.89, blue: 0.89, alpha: 1)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    func layout() {
        self.addSubview(circleView)
        self.addSubview(locLabel)
        self.addSubview(heartImageView)
        self.addSubview(line)
        self.addSubview(idLabel)
        
        circleView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(circleView.snp.height)
        }
        locLabel.snp.makeConstraints { (make) in
            make.left.equalTo(circleView.snp.right).offset(20)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
            
        }
        heartImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-75)
            make.height.equalTo(20)
            make.width.equalTo(23)
        }
        line.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-1)
            make.width.equalToSuperview()
            make.height.equalTo(0.8)
            make.left.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
