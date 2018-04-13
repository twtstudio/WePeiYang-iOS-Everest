//
//  RateView.swift
//  WePeiYang
//
//  Created by Allen X on 10/27/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

//TODO: Non-Integer Star Image Using Core Animation
import UIKit


class RateView: UIView, UITextViewDelegate {
    var id: String = ""
    
    
    //var rating: Double
    @objc func dismissAnimated() {
        UIView.animate(withDuration: 0.7, animations: {
            self.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.frame.height)
        }) { (_: Bool) in
            UIViewController.current?.navigationItem.setHidesBackButton(false, animated: true)
            self.removeFromSuperview()
            
        }
    }
    
    
    @objc func submitRating() {
        var content: String? = nil
        var rating: Double = 3
        for view in self.subviews {
            if let foo = view as? UITextView {
                if foo.text != "写一点评论吧！" {
                    content = foo.text
                }
            }
            if let ratingView = view as? StarView {
                rating = ratingView.rating
            }
        }
        //Do The Uploading Shit
//        print(content)
        print(rating)
        User.shared.commitReview(content: content, bookid: id, rating: rating) {
            self.dismissAnimated()
            (UIViewController.current as? BookDetailViewController)?.reloadReview()
//            vc.reloadReview()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count < 1 {
            textView.text = "写一点评论吧！"
            textView.textColor = .gray
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "写一点评论吧！" {
            textView.text = ""
            textView.textColor = .black
        }
    }
}

extension RateView {
    convenience init(rating: Double, id: String) {
        self.init()
        self.id = id
        let blurEffect = UIBlurEffect(style: .light)
        let frostView = UIVisualEffectView(effect: blurEffect)
        
        self.addSubview(frostView)
        frostView.snp.makeConstraints {
            make in
            make.top.left.bottom.right.equalTo(self)
        }
        
        
        
        let starView = StarView(rating: rating, height: 36, tappable: true)
        let splitLine = UIView(color: .readRed)
        let textView = UITextView()
        textView.delegate = self
        textView.text = "写一点评论吧！"
        textView.textColor = .gray
        textView.backgroundColor = .clear
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = true
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .gray

        let cancelBtn = UIButton(backgroundImageName: "cancelBtn", desiredSize: CGSize(width: 30, height: 30))
        cancelBtn?.tintColor = .readRed
        cancelBtn?.addTarget(self, action: #selector(self.dismissAnimated), for: .touchUpInside)
        self.addSubview(cancelBtn!)
        cancelBtn?.snp.makeConstraints {
            make in
            make.left.equalTo(self).offset(30)
            make.top.equalTo(self).offset(100)
        }
        
        let submitBtn = UIButton(title: "提交")
        submitBtn.setTitleColor(.readRed, for: .normal)
        submitBtn.tintColor = .gray
        submitBtn.addTarget(self, action: #selector(self.submitRating), for: .touchUpInside)
        self.addSubview(submitBtn)
        submitBtn.snp.makeConstraints {
            make in
            make.top.equalTo(cancelBtn!)
            make.right.equalTo(self).offset(-30)
        }
        
        self.addSubview(starView)
        starView.snp.makeConstraints {
            make in
            make.centerX.equalTo(self)
            make.top.equalTo((cancelBtn?.snp.bottom)!).offset(20)
            
        }
        
        self.addSubview(splitLine)
        splitLine.snp.makeConstraints {
            make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.88)
            make.top.equalTo(starView.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            make.height.equalTo(2)
        }
        
        self.addSubview(textView)
        textView.snp.makeConstraints {
            make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.88)
            make.top.equalTo(starView.snp.bottom).offset(30)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
        }
        assignGestureRecognizerToView()
    }
    
}


private extension RateView {
    
    func assignGestureRecognizerToView() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissAnimated))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
}


extension UITextView {
    func shouldMoveUpWithKeyboard(flag: Bool) {
        //let moveDistance =
    }
    
    
}
