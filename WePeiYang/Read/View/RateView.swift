//
//  RateView.swift
//  WePeiYang
//
//  Created by Allen X on 10/27/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

//TODO: Non-Integer Star Image Using Core Animation



class RateView: UIView, UITextViewDelegate {
    var id: String = ""
    
    
    //var rating: Double
    func dismissAnimated() {
        UIView.animateWithDuration(0.7, animations: {
            self.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.frame.height)
        }) { (_: Bool) in
            UIViewController.currentViewController().navigationItem.setHidesBackButton(false, animated: true)
            self.removeFromSuperview()
            
        }
    }
    
    
    func submitRating() {
        var content: String? = nil
        var rating: Double = 3
        for view in self.subviews {
            if view.isKindOfClass(UITextView) {
                let foo = view as! UITextView
                if foo.text != "写一点评论吧！" {
                    content = foo.text
                }
            }
            if view.isKindOfClass(StarView) {
                rating = (view as! StarView).rating
            }
        }
        //Do The Uploading Shit
        print(content)
        print(rating)
        User.sharedInstance.commitReview(with: content, bookid: id, rating: rating) {
            self.dismissAnimated()
            let vc = UIViewController.currentViewController() as! BookDetailViewController
            vc.reloadReview()
        }
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if textView.text.characters.count < 1 {
            textView.text = "写一点评论吧！"
            textView.textColor = .grayColor()
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "写一点评论吧！" {
            textView.text = ""
            textView.textColor = .blackColor()
        }
    }
}

extension RateView {
    convenience init(rating: Double, id: String) {
        self.init()
        self.id = id
        let blurEffect = UIBlurEffect(style: .Light)
        let frostView = UIVisualEffectView(effect: blurEffect)
        
        self.addSubview(frostView)
        frostView.snp_makeConstraints {
            make in
            make.top.left.bottom.right.equalTo(self)
        }
        
        
        
        let starView = StarView(rating: rating, height: 36, tappable: true)
        let splitLine = UIView(color: readRed)
        let textView = UITextView()
        textView.delegate = self
        textView.text = "写一点评论吧！"
        textView.textColor = .grayColor()
        textView.backgroundColor = .clearColor()
        textView.userInteractionEnabled = true
        textView.scrollEnabled = true
        textView.font = UIFont.systemFontOfSize(18)
        textView.textColor = .grayColor()

        let cancelBtn = UIButton(backgroundImageName: "cancelBtn", desiredSize: CGSize(width: 30, height: 30))
        cancelBtn?.tintColor = readRed
        cancelBtn?.addTarget(self, action: #selector(self.dismissAnimated), forControlEvents: .TouchUpInside)
        self.addSubview(cancelBtn!)
        cancelBtn?.snp_makeConstraints {
            make in
            make.left.equalTo(self).offset(30)
            make.top.equalTo(self).offset(100)
        }
        
        let submitBtn = UIButton(title: "提交")
        submitBtn.setTitleColor(readRed, forState: .Normal)
        submitBtn.tintColor = .grayColor()
        submitBtn.addTarget(self, action: #selector(self.submitRating), forControlEvents: .TouchUpInside)
        self.addSubview(submitBtn)
        submitBtn.snp_makeConstraints {
            make in
            make.top.equalTo(cancelBtn!)
            make.right.equalTo(self).offset(-30)
        }
        
        self.addSubview(starView)
        starView.snp_makeConstraints {
            make in
            make.centerX.equalTo(self)
            make.top.equalTo((cancelBtn?.snp_bottom)!).offset(20)
            
        }
        
        self.addSubview(splitLine)
        splitLine.snp_makeConstraints {
            make in
            make.width.equalTo(UIScreen.mainScreen().bounds.width * 0.88)
            make.top.equalTo(starView.snp_bottom).offset(10)
            make.centerX.equalTo(self)
            make.height.equalTo(2)
        }
        
        self.addSubview(textView)
        textView.snp_makeConstraints {
            make in
            make.width.equalTo(UIScreen.mainScreen().bounds.width * 0.88)
            make.top.equalTo(starView.snp_bottom).offset(30)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
        }
        assignGestureRecognizerToView()
    }
    
}


private extension RateView {
    
    func assignGestureRecognizerToView() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissAnimated))
        swipeDown.direction = .Down
        addGestureRecognizer(swipeDown)
    }
    
}


extension UITextView {
    func shouldMoveUpWithKeyboard(flag: Bool) {
        //let moveDistance =
    }
    
    
}
