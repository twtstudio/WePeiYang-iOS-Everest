//
//  RecommendCell.swift
//  WePeiYang
//
//  Created by JinHongxu on 2016/10/25.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import UIKit

protocol RecommendBookViewDelegate {
    func pushDetailViewController(bookID: String)
}

class RecommendCell: UITableViewCell {
    
    var fooView: [RecommendBookView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    convenience init(model: [Recommender.RecommendedBook]) {
        self.init()
        
        let scrollView = UIScrollView()
        var imageViewArray = [UIImageView]()
        var titleLabelArray = [UILabel]()
        var authorLabelArray = [UILabel]()
        
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.contentSize = CGSize(width: 112*model.count, height: 200)
        //关闭滚动条显示
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        contentView.addSubview(scrollView)
        
        scrollView.snp_makeConstraints {
            make in
            make.height.equalTo(200)
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.right.equalTo(contentView)
        }
        
        for i in 0..<model.count {
            
            fooView.append(RecommendBookView(bookID: model[i].id))
            imageViewArray.append(UIImageView())
            titleLabelArray.append(UILabel(text: "\(model[i].title)"))
            authorLabelArray.append(UILabel(text: "\(model[i].author) 著"))
            
//            scrollView.addSubview(imageViewArray[i])
//            scrollView.addSubview(titleLabelArray[i])
//            scrollView.addSubview(authorLabelArray[i])
            
//            imageViewArray[i].userInteractionEnabled = true
//            imageViewArray[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RecommendCell.pushBookDetailController)))
//            titleLabelArray[i].userInteractionEnabled = true
//            titleLabelArray[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RecommendCell.pushBookDetailController)))
//            authorLabelArray[i].userInteractionEnabled = true
//            authorLabelArray[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RecommendCell.pushBookDetailController)))
            
            scrollView.addSubview(fooView[i])
            fooView[i].addSubview(imageViewArray[i])
            fooView[i].addSubview(titleLabelArray[i])
            fooView[i].addSubview(authorLabelArray[i])
            
            authorLabelArray[i].font = UIFont(name: "Arial", size: 14)
            authorLabelArray[i].textColor = UIColor.grayColor()
            
            imageViewArray[i].contentMode = .ScaleAspectFit
            imageViewArray[i].setImageWithURL(NSURL(string: "\(model[i].cover)")!)
            
//            if i == 0 {
//                imageViewArray[i].snp_makeConstraints {
//                    make in
//                    make.top.equalTo(scrollView).offset(16)
//                    make.left.equalTo(scrollView).offset(16)
//                    make.width.equalTo(80)
//                    make.height.equalTo(120)
//                }
//            } else {
//                imageViewArray[i].snp_makeConstraints {
//                    make in
//                    make.top.equalTo(scrollView).offset(16)
//                    make.left.equalTo(imageViewArray[i-1].snp_right).offset(32)
//                    make.width.equalTo(80)
//                    make.height.equalTo(120)
//                }
//            }

            fooView[i].tag = model[i].id
            if i == 0 {
                fooView[i].snp_makeConstraints {
                    make in
                    make.top.equalTo(scrollView).offset(8)
                    make.left.equalTo(scrollView).offset(8)
                    make.width.equalTo(112)
                    make.height.equalTo(186)
                }
            } else {
                fooView[i].snp_makeConstraints {
                    make in
                    make.top.equalTo(scrollView).offset(8)
                    make.left.equalTo(fooView[i-1].snp_right).offset(0)
                    make.width.equalTo(112)
                    make.height.equalTo(186)
                }
            }

            
            imageViewArray[i].snp_makeConstraints {
                make in
                make.top.equalTo(fooView[i]).offset(8)
                make.left.equalTo(fooView[i]).offset(8)
                make.width.equalTo(80)
                make.height.equalTo(120)
            }
            
            titleLabelArray[i].snp_makeConstraints {
                make in
                make.top.equalTo(imageViewArray[i].snp_bottom).offset(8)
                make.centerX.equalTo(imageViewArray[i])
                make.width.lessThanOrEqualTo(100)
            }
            
            authorLabelArray[i].snp_makeConstraints {
                make in
                make.top.equalTo(titleLabelArray[i].snp_bottom).offset(2 )
                make.centerX.equalTo(imageViewArray[i])
                make.width.lessThanOrEqualTo(100)
            }
            
        }
        
    }
}

class RecommendBookView: UIView {
    var delegate: RecommendBookViewDelegate?
    convenience init(bookID: Int) {
        self.init()
        self.tag = bookID
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.pushDetailViewController)))
    }
    
    func pushDetailViewController() {
//        print("fafa")
        delegate?.pushDetailViewController("\(self.tag)")
    }
}

