//
//  CourseAppraiseCell.swift
//  WePeiYang
//
//  Created by JinHongxu on 2017/1/13.
//  Copyright © 2017年 Qin Yubo. All rights reserved.
//

import UIKit

enum CourseAppraiseCellStyle {
    case main
    case normal
    case edit
}

protocol CourseAppraiseCellDelegate {
    func loadDetail()
}

class CourseAppraiseCell: UITableViewCell, UITextViewDelegate {
    var titleLabel = UILabel()
    var starView = StarView(rating: 5, height: 36, tappable: true)
    var delegate: CourseAppraiseCellDelegate?
    let textView = UITextView()
    let textViewPlaceHolder = "说点什么..."
    let detailButton = UIButton(title: "详细评价")
    let detailImageButton = UIButton()
    
    var id: Int?
    private var context = 0 //for kvo
    convenience init(title: String, style: CourseAppraiseCellStyle, id: Int) {
        self.init()
        
        self.id = id
        
        if style == .normal {
            contentView.addSubview(titleLabel)
            titleLabel.text = title
            titleLabel.snp.makeConstraints {
                make in
                make.top.equalTo(contentView).offset(8)
                make.left.equalTo(contentView).offset(16)
                make.right.equalTo(contentView).offset(-16)
            }
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byCharWrapping
            titleLabel.sizeToFit()
            
            contentView.addSubview(starView)
            starView.snp.makeConstraints {
                make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.centerX.equalTo(contentView)
                make.bottom.equalTo(contentView).offset(-8) //
            }
            let score = CourseAppraiseManager.shared.scoreArray[id]
            starView.stars[score-1].sendActions(for: .touchUpInside)
            starView.addObserver(self, forKeyPath: "rating", options: .new, context: &context)
            
        }
            
        else if style == .main {
            contentView.addSubview(titleLabel)
            titleLabel.text = title
            titleLabel.snp.makeConstraints {
                make in
                make.top.equalTo(contentView).offset(8)
                make.left.equalTo(contentView).offset(16)
                make.right.equalTo(contentView).offset(-16)
            }
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byCharWrapping
            titleLabel.sizeToFit()
            
            contentView.addSubview(starView)
            starView.snp.makeConstraints {
                make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.centerX.equalTo(contentView)
                // make.bottom.equalTo(detailButton).offset(-8) //
            }
            let score = CourseAppraiseManager.shared.scoreArray[id]
            starView.stars[score-1].sendActions(for: .touchUpInside)
            starView.addObserver(self, forKeyPath: "rating", options: .new, context: &context)
            
            contentView.addSubview(detailImageButton)
            detailImageButton.snp.makeConstraints {
                make in
                make.top.equalTo(starView.snp.bottom).offset(8) //
                make.left.equalTo(contentView).offset(16)
                make.bottom.equalTo(contentView).offset(-8)
                make.height.equalTo(30)
                make.width.equalTo(30)
            }
            if CourseAppraiseManager.shared.detailAppraiseEnabled == true {
                detailImageButton.setImage(UIImage(named: "ic_arrow_up"), for: .normal)
            } else {
                detailImageButton.setImage(UIImage(named: "ic_arrow_down"), for: .normal)
            }
            detailImageButton.tintColor = UIColor.gray
            detailImageButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
            
            contentView.addSubview(detailButton)
            detailButton.snp.makeConstraints {
                make in
                make.top.equalTo(starView.snp.bottom).offset(8) //
                make.left.equalTo(detailImageButton.snp.right)
                make.centerY.equalTo(detailImageButton)
                make.bottom.equalTo(contentView).offset(-8) //
            }
            detailButton.setTitleColor(UIColor.gray, for: .normal)
            detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
        }
            
            
        else if style == .edit {
            contentView.addSubview(titleLabel)
            titleLabel.text = title
            titleLabel.snp.makeConstraints {
                make in
                make.top.equalTo(contentView).offset(8)
                make.left.equalTo(contentView).offset(16)
                make.right.equalTo(contentView).offset(-16)
            }
            titleLabel.numberOfLines = 0
            titleLabel.lineBreakMode = .byCharWrapping
            titleLabel.sizeToFit()
            
            contentView.addSubview(textView)
            textView.snp.makeConstraints {
                make in
                make.left.equalTo(contentView).offset(16)
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.right.equalTo(contentView).offset(-16)
                make.height.equalTo(100)
                make.bottom.equalTo(contentView).offset(-8)
            }
            textView.delegate = self
            textView.text = CourseAppraiseManager.shared.note
            textView.textColor = UIColor.black
            if textView.text == "" {
                textView.text = textViewPlaceHolder
                textView.textColor = UIColor.lightGray
            }
            textView.font = UIFont(name: "Arial", size: 20)
        }
    }
    
    
    func detailButtonTapped() {
        delegate?.loadDetail()
        if CourseAppraiseManager.shared.detailAppraiseEnabled == true {
            detailImageButton.setImage(UIImage(named: "ic_arrow_up"), for: .normal)
        } else {
            detailImageButton.setImage(UIImage(named: "ic_arrow_down"), for: .normal)
        }
    }
    
    deinit{
        if id != 5 {
            starView.removeObserver(self, forKeyPath:"rating")
        }
    }
    
    
    //MARK: KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //print("Changed to:\(change![NSKeyValueChangeNewKey]!)")
        if let score = change![NSKeyValueChangeKey.newKey] as? Int {
            if id == 4 && CourseAppraiseManager.shared.detailAppraiseEnabled == false { // 总体打分
                for i in 0...4 {
                    CourseAppraiseManager.shared.scoreArray[i] = score
                }
            } else {
                CourseAppraiseManager.shared.scoreArray[id!] = score
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = textViewPlaceHolder
            textView.textColor = UIColor.lightGray
        }
        textView.resignFirstResponder()
    }

    func textViewDidChange(_ textView: UITextView) {
        CourseAppraiseManager.shared.note = textView.text
    }
}
