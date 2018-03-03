//
//  NewsTableViewCell.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/3.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    enum ImageStyle {
        case right
        case none
    }
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let descLabel = UILabel()
    let imgView = UIImageView()
    var imageStyle: ImageStyle

    init(style: UITableViewCellStyle, reuseIdentifier: String?, imageStyle: ImageStyle) {
        self.imageStyle = imageStyle
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        let screenWidth = UIScreen.main.bounds.width
        switch imageStyle {
        case .right:
            let titleWidth = screenWidth*3.0/5 - 30
            contentView.addSubview(titleLabel)
            titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            titleLabel.numberOfLines = 0
            titleLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(15)
                make.width.equalTo(titleWidth)
            }

            let imageWidth = screenWidth*2.0/5 - 30
            let imageHeight = imageWidth * 3.0 / 4.0

            contentView.addSubview(imgView)
            imgView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(15)
                make.left.equalTo(titleLabel.snp.right).offset(20)
                make.right.equalToSuperview().offset(-20)
                make.width.equalTo(imageWidth)
                make.height.equalTo(imageHeight)
            }

            contentView.addSubview(detailLabel)
            detailLabel.numberOfLines = 0
            detailLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
            detailLabel.textColor = .lightGray
            detailLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.width.equalTo(titleWidth)
                make.bottom.equalTo(imgView.snp.bottom)
            }

            contentView.addSubview(descLabel)
            descLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
            descLabel.textColor = .gray
            descLabel.snp.makeConstraints { make in
                make.top.equalTo(imgView.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-10)
            }
        case .none:
            let titleWidth = screenWidth - 40
            contentView.addSubview(titleLabel)
            titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            titleLabel.numberOfLines = 0
            titleLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview().offset(15)
                make.width.equalTo(titleWidth)
            }

            let imageWidth = screenWidth*2.0/5 - 30
            let imageHeight = imageWidth * 3.0 / 4.0

            contentView.addSubview(imgView)
            imgView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(15)
                make.left.equalTo(titleLabel.snp.right)
                make.right.equalToSuperview().offset(-20)
                make.width.equalTo(1)
                make.height.equalTo(imageHeight)
            }

            contentView.addSubview(detailLabel)
            detailLabel.numberOfLines = 0
            detailLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
            detailLabel.textColor = .lightGray
            detailLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.width.equalTo(titleWidth)
                make.bottom.equalTo(imgView.snp.bottom)
            }

            contentView.addSubview(descLabel)
            descLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
            descLabel.textColor = .gray
            descLabel.snp.makeConstraints { make in
                make.top.equalTo(imgView.snp.bottom).offset(20)
                make.left.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-10)
            }
        }

        let separatorLine = UIView()
        separatorLine.alpha = 0.4
        separatorLine.backgroundColor = .lightGray
        contentView.addSubview(separatorLine)
        separatorLine.snp.makeConstraints { make in
            make.height.equalTo(0.6)
            make.bottom.equalToSuperview()//.offset(-1)
            make.left.right.equalToSuperview()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
