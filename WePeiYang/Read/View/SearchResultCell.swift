//
//  SearchResultCell.swift
//  YuePeiYang
//
//  Created by Halcao on 2016/10/27.
//  Copyright © 2016年 Halcao. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    var cover = UIImageView()
    var title = UILabel()
    var rate = UILabel()
    var author = UILabel()
    var publisher = UILabel()
    var year = UILabel()
    var star: StarView!
    let bigiPhoneWidth: CGFloat = 414.0

    convenience init(model: Librarian.SearchResult) {
        self.init()
        // FIXME: PlaceHolder
        let fuckUrl = model.coverURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        if let url = NSURL(string: fuckUrl) {
            cover.setImageWithURL(url, placeholderImage: UIImage(named: "placeHolderImageForBookCover"))
            print(fuckUrl)
        }
        title.text = "\(model.title)"
        rate.text = "\(model.rating)分"
        author.text = "著者: \(model.author)"
        publisher.text = "出版社: \(model.publisher)"
        year.text = "出版日期: \(model.year)"
        star = StarView(rating: model.rating, height: 15, tappable: false)
        
        contentView.addSubview(star)
        contentView.addSubview(cover)
        contentView.addSubview(title)
        contentView.addSubview(rate)
        contentView.addSubview(author)
        contentView.addSubview(publisher)
        contentView.addSubview(year)
        
        cover.contentMode = .ScaleAspectFit
        cover.sizeToFit()
//        cover = {
//            $0.contentMode = .ScaleAspectFit
//            return $0
//        }(UIImageView())
        cover.snp_makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(10)
            make.height.equalTo(120)
            make.width.equalTo(80)
        }
        
        
        if UIScreen.mainScreen().bounds.size.width > bigiPhoneWidth {
            title.font = UIFont.systemFontOfSize(18)
            rate.font = UIFont.systemFontOfSize(19)
        } else {
            title.font = UIFont.systemFontOfSize(16)
            rate.font = UIFont.systemFontOfSize(17)
        }
        
        title.sizeToFit()
        title.numberOfLines = 1
        let width = UIScreen.mainScreen().bounds.size.width
        title.preferredMaxLayoutWidth = width - 40;
        title.snp_makeConstraints { make in
            make.left.equalTo(cover.snp_right).offset(10)
            make.top.equalTo(contentView).offset(15)
            make.right.equalTo(rate.snp_left).offset(-10)
        }
        
        year.textColor = UIColor(red:0.58, green:0.58, blue:0.59, alpha:1.00)
        year.sizeToFit()
        year.font = UIFont.systemFontOfSize(13)
        year.snp_makeConstraints { make in
            make.bottom.equalTo(cover.snp_bottom)
            make.left.equalTo(cover.snp_right).offset(10)
            make.bottom.equalTo(contentView).offset(-20)
        }
        
        publisher.textColor = UIColor(red:0.58, green:0.58, blue:0.59, alpha:1.00)
        publisher.sizeToFit()
        publisher.numberOfLines = 1
        publisher.font = UIFont.systemFontOfSize(13)
        publisher.snp_makeConstraints { make in
            make.bottom.equalTo(year.snp_top).offset(-2)
            make.left.equalTo(cover.snp_right).offset(10)
            make.right.lessThanOrEqualTo(rate.snp_right)
        }
        
        author.textColor = UIColor(red:0.58, green:0.58, blue:0.59, alpha:1.00)
        author.sizeToFit()
        author.numberOfLines = 1
        author.font = UIFont.systemFontOfSize(13)
        author.snp_makeConstraints { make in
            make.bottom.equalTo(publisher.snp_top).offset(-2)
            make.left.equalTo(cover.snp_right).offset(10)
            make.right.lessThanOrEqualTo(rate.snp_right)
        }
        
        rate.sizeToFit()
        rate.textColor = UIColor(red:0.91, green:0.20, blue:0.20, alpha:1.00)
        rate.snp_makeConstraints { make in
            make.right.equalTo(contentView).offset(-30)
            make.top.equalTo(contentView).offset(35)
        }
        
        star.snp_makeConstraints { make in
            make.centerY.equalTo(rate.snp_centerY)
            make.left.equalTo(cover.snp_right).offset(10)
        }
        

    }
}
