//
//  BannerCell.swift
//  WePeiYang
//
//  Created by Rick on 2018/2/8.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SDWebImage


class BannerCell: UICollectionViewCell {
    
    // MARK: 内部属性
    fileprivate var imgView: UIImageView!
    fileprivate var descLabel: UILabel!
    fileprivate var bottomView: UIView!
    fileprivate var twtLabel: UILabel!
    
    // MARK: - 对外方法
    var imgSource: ImgSource = ImgSource.LOCAL(name: "placeholder")  {
        didSet {
            switch imgSource {
            case let .SERVER(url):
                imgView.sd_setImage(with: url)
            case let .LOCAL(name):
                imgView.image = UIImage(named: name)
            }
        }
    }
    
    var placeholderImage: UIImage?
    var descText: String? {
        didSet {
            descLabel.isHidden  = (descText == nil) ? true : false
            bottomView.isHidden = (descText == nil) ? true : false
            descLabel.text = descText
        }
    }
    
    var imageContentModel: UIViewContentMode = .scaleAspectFill {
        didSet {
            imgView.contentMode = imageContentModel
        }
    }
    
    var descLabelFont: UIFont = UIFont(name: "Helvetica-Bold", size: 40)! {
        didSet {
            descLabel.font = descLabelFont
        }
    }
    
    var descLabelTextColor: UIColor = UIColor.black {
        didSet {
            descLabel.textColor = descLabelTextColor
        }
    }
    
    var bottomViewlHeight: CGFloat = 60 {
        didSet {
            descLabel.frame.size.height = bottomViewlHeight
        }
    }
    
    var descLabelTextAlignment: NSTextAlignment = .left {
        didSet {
            descLabel.textAlignment = descLabelTextAlignment
        }
    }
    
    var bottomViewBackgroundColor: UIColor = UIColor.white.withAlphaComponent(1) {
        didSet {
            bottomView.backgroundColor = bottomViewBackgroundColor
        }
    }
    
    override var frame: CGRect {
        didSet {
            bounds.size = frame.size
        }
    }
    
    
    // MARK: - initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupImgView()
        setupDescLabel()
        setupBottomView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("BannerCell  deinit")
    }
    
    
    // MARK: layoutSubviews 方法
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - bottomViewlHeight)
        
        if let _ = descText {
            let margin: CGFloat = 16
            let labelWidth = imgView.bounds.width - 2 * margin
            let bottomViewHeight = bottomViewlHeight
            let bottomViewY = bounds.height - bottomViewHeight
            let labelHeight = bottomViewlHeight - 50
            let labelY = bounds.height - bottomViewHeight + 20
            descLabel.frame = CGRect(x: margin, y: labelY, width: labelWidth, height: labelHeight)
            bottomView.frame = CGRect(x: 0, y: bottomViewY, width: imgView.bounds.width, height: bottomViewlHeight)
            bringSubview(toFront: descLabel)
        }
    }
}


// MARK: - 控件初始化
extension BannerCell {
    
    fileprivate func setupImgView() {
        imgView = UIImageView()
        imgView.contentMode = imageContentModel
        imgView.clipsToBounds = true
        addSubview(imgView)
    }
    
    fileprivate func setupDescLabel() {
        descLabel = UILabel()
        descLabel.text = descText
        descLabel.font = descLabelFont
        descLabel.textColor = descLabelTextColor
        descLabel.frame.size.height = bottomViewlHeight
        descLabel.textAlignment = descLabelTextAlignment
        descLabel.numberOfLines = 0
        addSubview(descLabel)
        descLabel.isHidden = true
    }
    
    fileprivate func setupBottomView() {
        bottomView = UIView()
        bottomView.backgroundColor = bottomViewBackgroundColor
        twtLabel = UILabel(frame: CGRect(x: 15, y: 5, width: 120, height: 20))
        twtLabel.text = "天外天新闻中心"
        twtLabel.font = UIFont.systemFont(ofSize: 13)
        twtLabel.textColor = #colorLiteral(red: 0.4744554758, green: 0.4745411277, blue: 0.4744499922, alpha: 1)
        bottomView.addSubview(twtLabel)
        addSubview(bottomView)
        bottomView.isHidden = true
    }
}

