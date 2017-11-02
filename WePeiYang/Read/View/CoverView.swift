//
//  CoverView.swift
//  WePeiYang
//
//  Created by Allen X on 10/27/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

let computedBGViewHeight = UIScreen.main.bounds.height * 0.52
let computedBGViewWidth = UIScreen.main.bounds.width

class CoverView: UIView {
    
    var book: Book!
    var coverView: UIImageView!
    var computedBGView: UIView!
    var titleLabel: UILabel!
    var authorLabel: UILabel!
    var publisherLabel: UILabel!
    var yearLabel: UILabel!
    var scoreLabel: UILabel!
    var favBtn: UIButton!
    var reviewBtn: UIButton!
    var starReviewLabel: UILabel!
    var summaryLabel: UILabel!
    
    var summaryTitleLabel: UILabel!
    var tapToSeeMoreBtn: UIButton!
    
    convenience init(book: Book) {
        self.init()
        self.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1)
        self.book = book
        coverView = {
            $0.contentMode = UIViewContentMode.scaleAspectFit
            $0.sizeToFit()
            $0.layer.masksToBounds = false;
            $0.layer.shadowOffset = CGSize(width: -15, height: -15)
            $0.layer.shadowRadius = 10;
            $0.layer.shadowOpacity = 0.5;
            return $0
        }(UIImageView())
        
        computedBGView = UIView()
        
        //coverView.setImageWithURL(NSURL(string: book.coverURL))
        titleLabel = {
            $0.font = UIFont.boldSystemFont(ofSize: 24)
            $0.numberOfLines = 1
            return $0
        }(UILabel(text: book.title, color: .black))
        
        authorLabel = {
            //$0.font = UIFont.boldSystemFont(ofSize: 14)
            $0.font = UIFont.systemFont(ofSize: 14)
            return $0
        }(UILabel(text: "作者："+book.author, color: .gray))
        
        publisherLabel = {
            //$0.font = UIFont.boldSystemFont(ofSize: 14)
            $0.font = UIFont.systemFont(ofSize: 14)
            return $0
        }(UILabel(text: "出版社："+book.publisher, color: .gray))
        
        yearLabel = {
            //$0.font = UIFont.boldSystemFont(ofSize: 14)
            $0.font = UIFont.systemFont(ofSize: 14)
            return $0
        }(UILabel(text: "出版时间："+book.year, color: .gray))
        
        //Gotta refine it
        scoreLabel = {
            $0.font = UIFont(name: "Menlo-BoldItalic", size: 60)
            return $0
        }(UILabel(text: "\(book.rating)", color: .readRed))
        
        favBtn = UIButton(title: "收藏", borderWidth: 1.5, borderColor: .readRed)
        favBtn.addTarget(self, action: #selector(self.favourite), for: .touchUpInside)
        reviewBtn = UIButton(title: "写书评", borderWidth: 1.5, borderColor: .readRed)
        reviewBtn.addTarget(self, action: #selector(self.presentRateView), for: .touchUpInside)
        
        starReviewLabel = {
            //TODO: DO OTHER UI MODIFICATIONS
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            return $0
        }(UILabel(text: "This is a very great book", color: .gray))
        
        summaryTitleLabel = {
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.font = UIFont.systemFont(ofSize: 12)
            return $0
        }(UILabel(text: "图书简介", color: .gray))
        
        summaryLabel = {
            //TODO: DO OTHER UI MODIFICATIONS & Click to read more
            $0.numberOfLines = 7
            $0.font = UIFont.systemFont(ofSize: 15)
            return $0
        }(UILabel(text: book.summary, color: .gray))
        
        tapToSeeMoreBtn = {
            $0.addTarget(self, action: #selector(self.tapToSeeMore), for: .touchUpInside)
            $0.setTitleColor(.readRed, for: .normal)
            $0.titleLabel!.font = UIFont.systemFont(ofSize: 15)
            return $0
        }(UIButton(title: "点击查看更多"))
        
        //let img = UIImage(named: "cover4")
        
      //  let imageURL = NSURL(string: book.coverURL)
        
//        let fuckStr = book.coverURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let fuckStr = book.coverURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        _ = URL(string: fuckStr)
//        let imageRequest = NSURLRequest(url: fuckURL!)
        
        // FIXME: image
//        coverView.setImageWithURLRequest(imageRequest, placeholderImage: nil, success: { (_, _, img) in
//            if img.size.height > img.size.width {
//                self.coverView.image = UIImage.resizedImageKeepingRatio(img, scaledToWidth: UIScreen.main.bounds.width / 2)
//            } else {
//                self.coverView.image = UIImage.resizedImageKeepingRatio(img, scaledToHeight: UIScreen.main.bounds.height * 0.52 * 0.6)
//            }
//            
//            let fooRGB = self.coverView.image?.smartAvgRGB()
//            self.computedBGView.backgroundColor = UIColor(red: (fooRGB?.red)!, green: (fooRGB?.green)!, blue: (fooRGB?.blue)!, alpha: (fooRGB?.alpha)!)
////            //NavigationBar 的背景，使用了View
////            UIViewController.current?.navigationController!.jz_navigationBarBackgroundAlpha = 0;
////            let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIViewController.current?.view.frame.size.width, height: UIViewController.current?.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height))
////            UIViewController.current?.navigationController?.navigationBar.tintColor = .white
////            bgView.backgroundColor = self.computedBGView.backgroundColor
//////            log.any(self.computedBGView.backgroundColor)/
//////            log.any(bgView.backgroundColor)/
////            UIViewController.current?.view.addSubview(bgView)
//        }) { (_, _, _) in
//            guard let img = UIImage(named: "placeHolderImageForBookCover") else {
//                self.coverView.backgroundColor = .gray
//                self.computedBGView.backgroundColor = .gray
//                
//                //NavigationBar 的背景，使用了View
//                UIViewController.current?.navigationController!.jz_navigationBarBackgroundAlpha = 0;
//                let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIViewController.current?.view.frame.size.width, height: UIViewController.current?.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height))
//                UIViewController.current?.navigationController?.navigationBar.tintColor = .white
//                bgView.backgroundColor = self.computedBGView.backgroundColor
////                log.any(self.computedBGView.backgroundColor)/
////                log.any(bgView.backgroundColor)/
//                UIViewController.current?.view.addSubview(bgView)
//                
//                return
//            }
//            self.coverView.image = img
//            let fooRGB = self.coverView.image?.smartAvgRGB()
//            self.computedBGView.backgroundColor = UIColor(red: (fooRGB?.red)!, green: (fooRGB?.green)!, blue: (fooRGB?.blue)!, alpha: (fooRGB?.alpha)!)
//            //NavigationBar 的背景，使用了View
//            UIViewController.current?.navigationController!.jz_navigationBarBackgroundAlpha = 0;
//            let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIViewController.current?.view.frame.size.width, height: UIViewController.current?.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height))
//            UIViewController.current?.navigationController?.navigationBar.tintColor = .white
//            bgView.backgroundColor = self.computedBGView.backgroundColor
////            log.any(self.computedBGView.backgroundColor)/
////            log.any(bgView.backgroundColor)/
//            UIViewController.current?.view.addSubview(bgView)
//        }
        
        
        //Can't do it outside the Asynchronous Closure
        //        let fooRGB = coverView.image?.smartAvgRGB()
        //        computedBGView.backgroundColor = UIColor(red: (fooRGB?.red)!, green: (fooRGB?.green)!, blue: (fooRGB?.blue)!, alpha: (fooRGB?.alpha)!)
        
        computedBGView.addSubview(coverView)
        coverView.snp.makeConstraints {
            make in
            make.center.equalTo(computedBGView.center)
        }
        
        self.addSubview(computedBGView)
        computedBGView.snp.makeConstraints {
            make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(computedBGViewHeight)
        }
        
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            make in
            make.left.equalTo(self).offset(20)
            make.width.lessThanOrEqualTo(248)
            make.top.equalTo(computedBGView.snp.bottom).offset(20)
        }
        
        self.addSubview(authorLabel)
        authorLabel.snp.makeConstraints {
            make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
        }
        
        self.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints {
            make in
            make.centerY.equalTo(authorLabel)
            make.right.equalTo(self).offset(-20)
        }
        
        self.addSubview(publisherLabel)
        publisherLabel.snp.makeConstraints {
            make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(authorLabel.snp.bottom).offset(4)
            make.right.lessThanOrEqualTo(scoreLabel.snp.left).offset(-10)
            
        }
        
        self.addSubview(yearLabel)
        yearLabel.snp.makeConstraints {
            make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(publisherLabel.snp.bottom).offset(4)
        }
        
        self.addSubview(favBtn)
        favBtn.snp.makeConstraints {
            make in
            make.left.equalTo(yearLabel)
            make.top.equalTo(yearLabel).offset(38)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }
        
        self.addSubview(reviewBtn)
        reviewBtn.snp.makeConstraints {
            make in
            make.top.equalTo(favBtn)
            make.right.equalTo(self.snp.right).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }
        
        
        self.addSubview(summaryTitleLabel)
        summaryTitleLabel.snp.makeConstraints {
            make in
            make.top.equalTo(favBtn.snp.bottom).offset(28)
            make.left.equalTo(favBtn)
        }
        
        self.addSubview(summaryLabel)
        summaryLabel.snp.makeConstraints {
            make in
            make.top.equalTo(summaryTitleLabel.snp.bottom).offset(20)
            make.left.equalTo(summaryTitleLabel)
            make.right.equalTo(reviewBtn)
        }
        
        self.addSubview(tapToSeeMoreBtn)
        tapToSeeMoreBtn.snp.makeConstraints {
            make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(4)
            make.left.equalTo(summaryLabel)
        }
        
        self.snp.makeConstraints {
            make in
            make.width.equalTo(UIScreen.main.bounds.width)
            //make.height.equalTo(UIScreen.main.bounds.height + 100)
            make.bottom.equalTo(tapToSeeMoreBtn.snp.bottom).offset(18)
        }
    }
}

private extension UIButton {
    convenience init(title: String, borderWidth: CGFloat, borderColor: UIColor) {
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(borderColor, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        //titleLabel?.sizeToFit()
        tintColor = borderColor
        
        
        //TODO: self-sizing UIButton with Snapkit
        //        frame.size = CGSize(width: ((titleLabel?.frame.width)! + 60), height: ((titleLabel?.frame.height)! + 20))
        //        print((titleLabel?.frame.width)! + 50)
        //let titleSize = NSString(string: title).sizeWithAttributes()
        //sizeThatFits(CGSize(width: ((titleLabel?.frame.width)! + 50), height: ((titleLabel?.frame.height)! + 20)))
        self.layer.cornerRadius = 3
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}


extension CoverView: UIWebViewDelegate {
    func presentRateView() {
        let rateView = RateView(rating: 3.0, id: "\(book.id)")
        //self.addSubview(rateView)
        
        
        //        UIViewController.current?.view.addSubview(rateView)
        //        rateView.snp.makeConstraints {
        //            make in
        //            make.height.equalTo(UIScreen.main.bounds.height)
        //            make.width.equalTo(UIScreen.main.bounds.width)
        //            make.top.equalTo(UIViewController.current?.view)
        //            make.left.equalTo(UIViewController.current?.view)
        //        }mine
        
        //        UIViewController.current?.navigationview.addSubview(rateView)
        //UIViewController.current?.navigationController?.view.addSubview(rateView)
        UIViewController.current?.view.addSubview(rateView)
        //rateView.superview!.bringSubviewToFront(rateView)
        UIViewController.current?.navigationItem.setHidesBackButton(true, animated: true)
        rateView.frame = CGRect(x: 0, y: self.frame.height, width: 0, height: self.frame.height/4)
        UIView.beginAnimations("ratingViewPopUp", context: nil)
        UIView.setAnimationDuration(0.6)
        rateView.frame = self.frame
        UIView.commitAnimations()
        
    }
    
    
    override func willRemoveSubview(_ subview: UIView) {
        UIViewController.current?.navigationItem.setHidesBackButton(false, animated: true)
    }
    
    func favourite() {
        User.shared.addFavorite(id: "\(self.book.id)") {
//            MsgDisplay.showSuccessMsg("添加成功")
        }
        //Call `favourite` method of a user
    }
    
    func tapToSeeMore() {
        
        let blurEffect = UIBlurEffect(style: .light)
        let frostView = UIVisualEffectView(effect: blurEffect)
        
        let doneBtn: UIButton = {
            $0.addTarget(self, action: #selector(self.tapAgainToDismiss), for: .touchUpInside)
            $0.setTitleColor(.readRed, for: .normal)
            return $0
        }(UIButton(title: "完成"))
        
        
        UIViewController.current?.navigationItem.setHidesBackButton(true, animated: true)
        frostView.frame = self.frame
        frostView.addSubview(doneBtn)
        doneBtn.snp.makeConstraints {
            make in
            make.left.equalTo(frostView).offset(20)
            make.top.equalTo(frostView).offset(100)
        }
        UIViewController.current?.view.addSubview(frostView)
//        frostView.snp.makeConstraints {
//            make in
//            make.left.equalTo(UIViewController.current?.view)
//            make.right.equalTo(UIViewController.current?.view)
//            make.top.equalTo(UIViewController.current?.view)
//            make.bottom.equalTo(UIViewController.current?.view)
//        }
        
        let summaryDetailView = UIWebView(htmlString: book.summary)
        frostView.addSubview(summaryDetailView)
        //summaryDetailView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        summaryDetailView.snp.makeConstraints {
            make in
            make.top.equalTo(doneBtn.snp.bottom).offset(20)
            make.left.equalTo(frostView).offset(20)
            make.right.equalTo(frostView).offset(-20)
            make.bottom.equalTo(frostView)
        }
        summaryDetailView.alpha = 0
        UIView.beginAnimations("summaryDetailViewFadeIn", context: nil)
        UIView.setAnimationDuration(0.6)
        summaryDetailView.alpha = 1
        UIView.commitAnimations()
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAgainToDismiss))
//        summaryDetailView.addGestureRecognizer(tap)
    }
    
    func tapAgainToDismiss() {
        for fooView in (UIViewController.current?.view.subviews)! {
            if fooView is UIVisualEffectView {
                UIView.animate(withDuration: 0.7, animations: {
                    fooView.alpha = 0
                    }, completion: { (_) in
                        UIViewController.current?.navigationItem.setHidesBackButton(false, animated: true)
                        fooView.removeFromSuperview()
                })
            }
        }
    }
}


private extension UIWebView {
    convenience init(htmlString: String) {
        self.init()
        backgroundColor = .clear
        isOpaque = false
        isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        loadHTMLString(htmlString, baseURL: nil)
    }
}
