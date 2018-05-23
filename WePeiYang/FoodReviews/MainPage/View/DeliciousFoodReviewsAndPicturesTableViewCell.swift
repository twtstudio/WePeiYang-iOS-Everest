//
//  DeliciousFoodReviewsAndPicturesTableViewCell.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/5/10.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class DeliciousFoodReviewsAndPicturesTableViewCell: UITableViewCell {
    
    var foodImageView: UIImageView!
    var rankImageView: UIImageView!
    var customerLabel: UILabel!
    var dateLabel: UILabel!
    var commentLabel: UILabel!
    var imageViews: [UIImageView] = [UIImageView(image: UIImage(color: .yellow)), UIImageView(image: UIImage(color: .purple)), UIImageView(image: UIImage(color: .green)), UIImageView(image: UIImage(color: .yellow))]
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        foodImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 150))
        foodImageView.backgroundColor = .black
        contentView.addSubview(foodImageView)
        
        
        customerLabel = UILabel()
        customerLabel.text = "Oceansaf"
        customerLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(customerLabel)
        customerLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(foodImageView.snp.right).offset(10)
            make.height.equalTo(15)
            make.right.equalTo(-120)
        }
        customerLabel.textAlignment = .left
        
        dateLabel = UILabel()
        dateLabel.text = "2017年12月4日"
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(customerLabel.snp.bottom).offset(2)
            make.left.equalTo(foodImageView.snp.right).offset(10)
            make.height.equalTo(15)
            make.right.equalTo(-120)
        }
        dateLabel.textAlignment = .left
        
        
        let WIDTH:CGFloat = (UIScreen.main.bounds.size.width-10-10-120-10-10-3*3)/4
        for index in 0...3 {
            if index == 0 {
                let imgView = imageViews[0]
                self.contentView.addSubview(imgView)
                imgView.snp.makeConstraints { make in
                    make.left.equalToSuperview().inset(120+10)
                    make.top.equalTo(dateLabel.snp.bottom).offset(5)
                    make.height.width.equalTo(WIDTH)
                }
            } else {
                let imgView = imageViews[index]
                self.contentView.addSubview(imgView)
                imgView.snp.makeConstraints { make in
                    make.left.equalTo(imageViews[index-1].snp.right).offset(3)
                    make.top.equalTo(imageViews[index-1].snp.top)
                    make.height.width.equalTo(WIDTH)
                }
            }
        }
        
        
        commentLabel = UILabel()
        commentLabel.text = "和过v 分别为色调何耳机客家空间热裤就好好看加热是任何人特色 4额就 543 元54 开得上翻滚一天天地方也太单纯u 元"
        commentLabel.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(imageViews[0].snp.bottom).offset(5)
            make.left.equalTo(foodImageView.snp.right).offset(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-15)
        }
        commentLabel.numberOfLines = 0
        commentLabel.textAlignment = .left
        commentLabel.sizeToFit()
        
        rankImageView = UIImageView()
        rankImageView.backgroundColor = .red
        contentView.addSubview(rankImageView)
        rankImageView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(100)
            make.height.equalTo(20)
        }
        
        
    }
    
    override var frame: CGRect {
        didSet {
            var newFrame = frame
            newFrame.origin.x += 10
            newFrame.size.width -= 20
            newFrame.size.height -= 10
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 2
            super.frame = newFrame
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
