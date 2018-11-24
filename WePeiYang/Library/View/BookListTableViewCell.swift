//
//  BookListTableViewCell.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/11/1.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class BookListTableViewCell: UITableViewCell {
    
    let listCard = CardView()
    let listImage = UIImageView()
    let listLabel = UILabel()
    var book: ListBook? {
        didSet {
            if let book = book {
                title.text = book.bookName.replacingOccurrences(of: "/", with: "")
                number.text = "借阅数 " + "\(book.borrowNum)"
            }
        }
    }
    private let title = UILabel()
    private let number = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        listCard.shadowColor = UIColor.lightGray
        listCard.cardRadius = 8
        listCard.isUserInteractionEnabled = false
        addSubview(listCard)
        
        title.textColor = LibraryMainViewController.fontDarkColor
        title.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        title.numberOfLines=0
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        number.textColor = LibraryMainViewController.fontGrayColor
        number.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        
        listCard.addSubview(title)
        listCard.addSubview(number)
        
        switch reuseIdentifier {
        case "listTopTableViewCellID":
            listCard.addSubview(listImage)
            remakeConstraints(listImage: listImage)
        default:
            listCard.addSubview(listLabel)
            listLabel.textAlignment = .center
            listLabel.font = UIFont.systemFont(ofSize: 18)
            listLabel.numberOfLines = 0
            remakeConstraints(listImage: listLabel)
        }
    }
    
    private func remakeConstraints(listImage: UIView) {
        let padding: CGFloat = 20
        let paddingTop: CGFloat = 25
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        listCard.sizeToFit()
        listCard.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(frame.height * 0.05)
            make.left.equalTo(contentView).offset(frame.width * 0.05)
            make.right.equalTo(contentView).offset(-frame.width * 0.05)
            make.bottom.equalTo(contentView).offset(-frame.height * 0.05)
        }
        listImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(listCard).offset(paddingTop)
            make.left.equalTo(listCard).offset(padding)
            make.bottom.equalTo(listCard).offset(-paddingTop)
            make.width.equalTo(listImage.snp.height)
        }
        title.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(listCard).offset(10)
            make.left.equalTo(listImage.snp.right).offset(padding)
            make.right.equalTo(listCard).offset(-padding)
        }
        number.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.left.equalTo(title)
            make.right.equalTo(listCard).offset(-padding)
            make.bottom.equalTo(listCard).offset(-10)
            make.height.equalTo(number.font.lineHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
