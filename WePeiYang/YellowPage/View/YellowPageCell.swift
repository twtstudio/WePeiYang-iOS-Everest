//
//  YellowPageCell.swift
//  YellowPage
//
//  Created by Halcao on 2017/2/22.
//  Modified by Halcao on 2017/7/18.
//  Copyright © 2017年 Halcao. All rights reserved.
//

import UIKit
import SwiftMessages

// haeder: the view on top
// section: which can be fold and unfold
// item: for each item in section
// detailed: detailed info
enum YellowPageCellStyle: String {
    case header = "headerCell"
    case section = "sectionCell"
    case item = "itemCell"
    case detailed = "detailedCell"
}

class YellowPageCell: UITableViewCell {
    var canUnfold = true {
        didSet {
            if self.canUnfold && style == .section {
                arrowView.image = UIImage(named: "ic_arrow_right")
            } else {
                arrowView.image = UIImage(named: "ic_arrow_down")
            }
        }
    }
    var name = ""
    let arrowView = UIImageView()
    var countLabel: UILabel! = nil
    var style: YellowPageCellStyle = .header
    var detailedModel: ClientItem! = nil
    var commonView: CommonUsedView! = nil
    var likeView: ExtendedButton! = nil
    var phoneLabel: UILabel!

    convenience init(with style: YellowPageCellStyle, name: String) {
        self.init(style: .default, reuseIdentifier: style.rawValue)

        self.style = style
        switch style {
        case .header:
            commonView = CommonUsedView(with: [])
            //            commonView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            self.contentView.addSubview(commonView)
            commonView.snp.makeConstraints { make in
                make.width.equalTo(UIScreen.main.bounds.size.width)
                make.height.equalTo(200)
                make.top.equalTo(contentView)
                make.left.equalTo(contentView)
                make.right.equalTo(contentView)
                make.bottom.equalTo(contentView)
            }

        case .section:
            arrowView.image = UIImage(named: self.canUnfold ? "ic_arrow_right" : "ic_arrow_down")
            arrowView.sizeToFit()
            self.contentView.addSubview(arrowView)
            arrowView.snp.makeConstraints { make in
                make.width.equalTo(15)
                make.height.equalTo(15)
                make.left.equalTo(contentView).offset(10)
                make.centerY.equalTo(contentView)
            }

            let label = UILabel()
            self.contentView.addSubview(label)
            // TODO: adjust font size
            label.text = name
            //label.font = UIFont.flexibleFont(with: 15)
            label.font = UIFont.systemFont(ofSize: 15)

            label.sizeToFit()
            label.snp.makeConstraints { make in
                make.top.equalTo(contentView).offset(15)
                make.left.equalTo(arrowView.snp.right).offset(10)
                make.centerY.equalTo(contentView)
                make.bottom.equalTo(contentView).offset(-15)
            }

            countLabel = UILabel()
            self.contentView.addSubview(countLabel)
            countLabel.textColor = UIColor.lightGray
            countLabel.font = UIFont.systemFont(ofSize: 14)
            countLabel.snp.makeConstraints { make in
                make.left.equalTo(contentView.snp.right).offset(-30)
                make.centerY.equalTo(contentView)
            }

        case .item:
            self.textLabel?.text = name
            //            textLabel?.font = UIFont.flexibleFont(with: 14)
            textLabel?.font = UIFont.systemFont(ofSize: 14)

            textLabel?.sizeToFit()
            //            textLabel?.snp.makeConstraints { make in
            //                make.top.equalTo(contentView).offset(11)
            //                make.centerY.equalTo(contentView)
            //                make.left.equalTo(contentView).offset(15)
            //                make.bottom.equalTo(contentView).offset(-11)
        //            }
        case .detailed:
            fatalError("这个方法请调用func init(with style: YellowPageCellStyle, model: ClientItem)")
        }

    }

    var nameLabel: UILabel!
    convenience init(with style: YellowPageCellStyle, model: ClientItem) {
        self.init(style: .default, reuseIdentifier: style.rawValue)
        guard style == .detailed else {
            return
        }
        self.detailedModel = model
        nameLabel = UILabel()
        nameLabel.text = model.name
        //        nameLabel.font = UIFont.flexibleFont(with: 14)
        // TODO: flexibleFont
        nameLabel.font = UIFont.systemFont(ofSize: 15)

        nameLabel.sizeToFit()

        // paste
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(YellowPageCell.longPressed))
        self.addGestureRecognizer(longPress)

        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(15)
            //make.bottom.equalTo(nameLabel).offset(-12)
        }

        phoneLabel = UILabel()
        let attributedString = NSAttributedString(string: model.phone, attributes: [NSAttributedStringKey.foregroundColor: YellowPageMainViewController.mainColor])
        //        let attributedString = NSAttributedString(string: model.phone, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])

        likeView = ExtendedButton()
        likeView.setImage(UIImage(named: model.isFavorite ? "like" : "dislike"), for: .normal)

        self.contentView.addSubview(likeView)
        likeView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView).offset(5)
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.right.equalTo(contentView).offset(-14)
            //            make.top.equalTo(nameLabel.snp.bottom).offset(13)
        }
        likeView.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)

        let phoneView = ExtendedButton()
        phoneView.setImage(UIImage(named: "phone"), for: .normal)
        phoneView.addTarget(self, action: #selector(phoneTapped(button:)), for: .touchUpInside)
        self.contentView.addSubview(phoneView)
        phoneView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.right.equalTo(likeView.snp.left).offset(-24)
            make.centerY.equalTo(likeView)
        }

        phoneLabel.attributedText = attributedString
        phoneLabel.font = UIFont.systemFont(ofSize: 14)
        phoneLabel.sizeToFit()
        self.contentView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(15)
            make.bottom.equalTo(contentView).offset(-10)
            //            make.centerY.equalTo(likeView.snp.centerY)
            make.right.lessThanOrEqualTo(phoneView.snp.left).offset(-10)
            make.top.equalTo(nameLabel).offset(30)
        }
        phoneLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        phoneLabel.addGestureRecognizer(gesture)

    }

    @objc func likeTapped() {
        if detailedModel.isFavorite {
            PhoneBook.shared.removeFavorite(with: self.detailedModel) {
                self.likeView.setImage(UIImage(named: "dislike"), for: .normal)
            }
            detailedModel.isFavorite = false
            // TODO: animation
        } else {
            PhoneBook.shared.addFavorite(with: self.detailedModel) {
                self.likeView.setImage(UIImage(named: "like1"), for: .normal)
            }
            detailedModel.isFavorite = true
            // TODO: animation
            // refresh data
        }
    }

    @objc func phoneTapped(button: UIButton) {
        if let url = URL(string: "telprompt://\(self.detailedModel.phone)") {
            UIApplication.shared.openURL(url)
        }
    }

    @objc func longPressed(sender: UITapGestureRecognizer) {
        if let text = UIPasteboard.general.string, text != self.detailedModel.phone {
            UIPasteboard.general.string = self.detailedModel.phone
        }
        SwiftMessages.showSuccessMessage(title: "操作成功", body: "已经复制到剪切板")
    }
}
