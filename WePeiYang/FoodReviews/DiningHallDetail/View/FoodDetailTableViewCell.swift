//
//  FoodDetailTableViewCell.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/5/3.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class FoodDetailTableViewCell: UITableViewCell {
    
    var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .red
        return imgView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "水煮鱼"
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .orange
        
        label.textAlignment = .left
        label.text = "¥12"
        return label
    }()
    
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .black
        
        label.textAlignment = .left
        label.text = "12"
        return label
    }()
    
    let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .black
        
        label.textAlignment = .left
        label.text = "12"
        return label
    }()
    
    let likeButton = ExtendedButton()
    let commentButton = ExtendedButton()
    let collectButton = ExtendedButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(imgView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(commentButton)
        contentView.addSubview(commentCountLabel)
        contentView.addSubview(collectButton)
        likeButton.setBackgroundImage(UIImage(named: "icon_心_n"), for: .normal)
        commentButton.setBackgroundImage(UIImage(named: "btn_4快速点评_n"), for: .normal)
        collectButton.setBackgroundImage(UIImage(named: "btn_9收藏_n"), for: .normal)
        
        imgView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(70)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalTo(imgView.snp.right).offset(10)
            make.height.equalTo(15)
            make.right.equalToSuperview().inset(80)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(imgView.snp.right).offset(10)
            make.height.equalTo(25)
            make.right.equalToSuperview().inset(150)
        }
        
        likeButton.snp.makeConstraints { make in
            make.left.equalTo(imgView.snp.right).offset(10)
            make.bottom.equalTo(imgView.snp.bottom)
            make.width.height.equalTo(18)
        }
        likeCountLabel.snp.makeConstraints { make in
            make.left.equalTo(likeButton.snp.right).offset(5)
            make.top.equalTo(likeButton.snp.top)
            make.bottom.equalTo(likeButton.snp.bottom)
            make.width.equalTo(30)
        }
        commentButton.snp.makeConstraints { make in
            make.left.equalTo(likeCountLabel.snp.right).offset(10)
            make.bottom.equalTo(imgView.snp.bottom)
            make.width.height.equalTo(18)
        }
        commentCountLabel.snp.makeConstraints { make in
            make.left.equalTo(commentButton.snp.right).offset(5)
            make.top.equalTo(commentButton.snp.top)
            make.bottom.equalTo(commentButton.snp.bottom)
            make.width.equalTo(30)
        }
        collectButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.bottom.equalTo(imgView.snp.bottom)
            make.width.height.equalTo(18)
        }
        
       
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
