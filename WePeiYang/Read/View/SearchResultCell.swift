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
        let fuckUrl = model.coverURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        let fuckUrl = model.coverURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        if let url = URL(string: fuckUrl) {
            //FIXME: image
//            cover.setImageWithURL(url, placeholderImage: UIImage(named: "placeHolderImageForBookCover"))
            print(url)
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
        
        cover.contentMode = .scaleAspectFit
        cover.sizeToFit()
//        cover = {
//            $0.contentMode = .scaleAspectFit
//            return $0
//        }(UIImageView())
        cover.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.top.equalTo(contentView).offset(10)
            make.height.equalTo(120)
            make.width.equalTo(80)
        }
        
        
        if UIScreen.main.bounds.size.width > bigiPhoneWidth {
            title.font = UIFont.systemFont(ofSize: 18)
            rate.font = UIFont.systemFont(ofSize: 19)
        } else {
            title.font = UIFont.systemFont(ofSize: 16)
            rate.font = UIFont.systemFont(ofSize: 17)
        }
        
        title.sizeToFit()
        title.numberOfLines = 1
        let width = UIScreen.main.bounds.size.width
        title.preferredMaxLayoutWidth = width - 40;
        title.snp.makeConstraints { make in
            make.left.equalTo(cover.snp.right).offset(10)
            make.top.equalTo(contentView).offset(15)
            make.right.equalTo(rate.snp.left).offset(-10)
        }
        
        year.textColor = UIColor(red:0.58, green:0.58, blue:0.59, alpha:1.00)
        year.sizeToFit()
        year.font = UIFont.systemFont(ofSize: 13)
        year.snp.makeConstraints { make in
            make.bottom.equalTo(cover.snp.bottom)
            make.left.equalTo(cover.snp.right).offset(10)
            make.bottom.equalTo(contentView).offset(-20)
        }
        
        publisher.textColor = UIColor(red:0.58, green:0.58, blue:0.59, alpha:1.00)
        publisher.sizeToFit()
        publisher.numberOfLines = 1
        publisher.font = UIFont.systemFont(ofSize: 13)
        publisher.snp.makeConstraints { make in
            make.bottom.equalTo(year.snp.top).offset(-2)
            make.left.equalTo(cover.snp.right).offset(10)
            make.right.lessThanOrEqualTo(rate.snp.right)
        }
        
        author.textColor = UIColor(red:0.58, green:0.58, blue:0.59, alpha:1.00)
        author.sizeToFit()
        author.numberOfLines = 1
        author.font = UIFont.systemFont(ofSize: 13)
        author.snp.makeConstraints { make in
            make.bottom.equalTo(publisher.snp.top).offset(-2)
            make.left.equalTo(cover.snp.right).offset(10)
            make.right.lessThanOrEqualTo(rate.snp.right)
        }
        
        rate.sizeToFit()
        rate.textColor = UIColor(red:0.91, green:0.20, blue:0.20, alpha:1.00)
        rate.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-30)
            make.top.equalTo(contentView).offset(35)
        }
        
        star.snp.makeConstraints { make in
            make.centerY.equalTo(rate.snp.centerY)
            make.left.equalTo(cover.snp.right).offset(10)
        }
        

    }
}
