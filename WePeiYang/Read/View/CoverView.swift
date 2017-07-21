//
//  CoverView.swift
//  WePeiYang
//
//  Created by Allen X on 10/27/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

let readRed = UIColor(red: 237.0/255.0, green: 84.0/255.0, blue: 80.0/255.0, alpha: 1.0)
let computedBGViewHeight = UIScreen.mainScreen().bounds.height * 0.52
let computedBGViewWidth = UIScreen.mainScreen().bounds.width

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
            $0.contentMode = UIViewContentMode.ScaleAspectFit
            $0.sizeToFit()
            $0.layer.masksToBounds = false;
            $0.layer.shadowOffset = CGSizeMake(-15, 15);
            $0.layer.shadowRadius = 10;
            $0.layer.shadowOpacity = 0.5;
            return $0
        }(UIImageView())
        
        computedBGView = UIView()
        
        //coverView.setImageWithURL(NSURL(string: book.coverURL))
        titleLabel = {
            $0.font = UIFont.boldSystemFontOfSize(24)
            $0.numberOfLines = 1
            return $0
        }(UILabel(text: book.title, color: .blackColor()))
        
        authorLabel = {
            //$0.font = UIFont.boldSystemFontOfSize(14)
            $0.font = UIFont.systemFontOfSize(14)
            return $0
        }(UILabel(text: "作者："+book.author, color: .grayColor()))
        
        publisherLabel = {
            //$0.font = UIFont.boldSystemFontOfSize(14)
            $0.font = UIFont.systemFontOfSize(14)
            return $0
        }(UILabel(text: "出版社："+book.publisher, color: .grayColor()))
        
        yearLabel = {
            //$0.font = UIFont.boldSystemFontOfSize(14)
            $0.font = UIFont.systemFontOfSize(14)
            return $0
        }(UILabel(text: "出版时间："+book.year, color: .grayColor()))
        
        //Gotta refine it
        scoreLabel = {
            $0.font = UIFont(name: "Menlo-BoldItalic", size: 60)
            return $0
        }(UILabel(text: "\(book.rating)", color: readRed))
        
        favBtn = UIButton(title: "收藏", borderWidth: 1.5, borderColor: readRed)
        favBtn.addTarget(self, action: #selector(self.favourite), forControlEvents: .TouchUpInside)
        reviewBtn = UIButton(title: "写书评", borderWidth: 1.5, borderColor: readRed)
        //reviewBtn.addTarget(self, action: #selector(self.presentReviewWritingView), forControlEvents: .TouchUpInside)
        reviewBtn.addTarget(self, action: #selector(self.presentRateView), forControlEvents: .TouchUpInside)
        
        starReviewLabel = {
            //TODO: DO OTHER UI MODIFICATIONS
            $0.font = UIFont.boldSystemFontOfSize(20)
            return $0
        }(UILabel(text: "This is a very great book", color: .grayColor()))
        
        summaryTitleLabel = {
            $0.font = UIFont.systemFontOfSize(12)
            return $0
        }(UILabel(text: "图书简介", color: .grayColor()))
        
        summaryLabel = {
            //TODO: DO OTHER UI MODIFICATIONS & Click to read more
            $0.numberOfLines = 7
            $0.font = UIFont.systemFontOfSize(15)
            return $0
        }(UILabel(text: book.summary, color: .grayColor()))
        
        tapToSeeMoreBtn = {
            $0.addTarget(self, action: #selector(self.tapToSeeMore), forControlEvents: .TouchUpInside)
            $0.setTitleColor(readRed, forState: .Normal)
            $0.titleLabel!.font = UIFont.systemFontOfSize(15)
            return $0
        }(UIButton(title: "点击查看更多"))
        
        //let img = UIImage(named: "cover4")
        
      //  let imageURL = NSURL(string: book.coverURL)
        let fuckStr = book.coverURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let fuckURL = NSURL(string: fuckStr)
        let imageRequest = NSURLRequest(URL: fuckURL!)
        
        coverView.setImageWithURLRequest(imageRequest, placeholderImage: nil, success: { (_, _, img) in
            if img.size.height > img.size.width {
                self.coverView.image = UIImage.resizedImageKeepingRatio(img, scaledToWidth: UIScreen.mainScreen().bounds.width / 2)
            } else {
                self.coverView.image = UIImage.resizedImageKeepingRatio(img, scaledToHeight: UIScreen.mainScreen().bounds.height * 0.52 * 0.6)
            }
            
            let fooRGB = self.coverView.image?.smartAvgRGB()
            self.computedBGView.backgroundColor = UIColor(red: (fooRGB?.red)!, green: (fooRGB?.green)!, blue: (fooRGB?.blue)!, alpha: (fooRGB?.alpha)!)
//            //NavigationBar 的背景，使用了View
//            UIViewController.currentViewController().navigationController!.jz_navigationBarBackgroundAlpha = 0;
//            let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIViewController.currentViewController().view.frame.size.width, height: UIViewController.currentViewController().navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.size.height))
//            UIViewController.currentViewController().navigationController?.navigationBar.tintColor = .whiteColor()
//            bgView.backgroundColor = self.computedBGView.backgroundColor
////            log.any(self.computedBGView.backgroundColor)/
////            log.any(bgView.backgroundColor)/
//            UIViewController.currentViewController().view.addSubview(bgView)
        }) { (_, _, _) in
            guard let img = UIImage(named: "placeHolderImageForBookCover") else {
                self.coverView.backgroundColor = .grayColor()
                self.computedBGView.backgroundColor = .grayColor()
                
                //NavigationBar 的背景，使用了View
                UIViewController.currentViewController().navigationController!.jz_navigationBarBackgroundAlpha = 0;
                let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIViewController.currentViewController().view.frame.size.width, height: UIViewController.currentViewController().navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.size.height))
                UIViewController.currentViewController().navigationController?.navigationBar.tintColor = .whiteColor()
                bgView.backgroundColor = self.computedBGView.backgroundColor
//                log.any(self.computedBGView.backgroundColor)/
//                log.any(bgView.backgroundColor)/
                UIViewController.currentViewController().view.addSubview(bgView)
                
                return
            }
            self.coverView.image = img
            let fooRGB = self.coverView.image?.smartAvgRGB()
            self.computedBGView.backgroundColor = UIColor(red: (fooRGB?.red)!, green: (fooRGB?.green)!, blue: (fooRGB?.blue)!, alpha: (fooRGB?.alpha)!)
            //NavigationBar 的背景，使用了View
            UIViewController.currentViewController().navigationController!.jz_navigationBarBackgroundAlpha = 0;
            let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIViewController.currentViewController().view.frame.size.width, height: UIViewController.currentViewController().navigationController!.navigationBar.frame.size.height+UIApplication.sharedApplication().statusBarFrame.size.height))
            UIViewController.currentViewController().navigationController?.navigationBar.tintColor = .whiteColor()
            bgView.backgroundColor = self.computedBGView.backgroundColor
//            log.any(self.computedBGView.backgroundColor)/
//            log.any(bgView.backgroundColor)/
            UIViewController.currentViewController().view.addSubview(bgView)
        }
        
        
        //Can't do it outside the Asynchronous Closure
        //        let fooRGB = coverView.image?.smartAvgRGB()
        //        computedBGView.backgroundColor = UIColor(red: (fooRGB?.red)!, green: (fooRGB?.green)!, blue: (fooRGB?.blue)!, alpha: (fooRGB?.alpha)!)
        
        computedBGView.addSubview(coverView)
        coverView.snp_makeConstraints {
            make in
            make.center.equalTo(computedBGView.center)
        }
        
        self.addSubview(computedBGView)
        computedBGView.snp_makeConstraints {
            make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(computedBGViewHeight)
        }
        
        
        self.addSubview(titleLabel)
        titleLabel.snp_makeConstraints {
            make in
            make.left.equalTo(self).offset(20)
            make.width.lessThanOrEqualTo(248)
            make.top.equalTo(computedBGView.snp_bottom).offset(20)
        }
        
        self.addSubview(authorLabel)
        authorLabel.snp_makeConstraints {
            make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(14)
        }
        
        self.addSubview(scoreLabel)
        scoreLabel.snp_makeConstraints {
            make in
            make.centerY.equalTo(authorLabel)
            make.right.equalTo(self).offset(-20)
        }
        
        self.addSubview(publisherLabel)
        publisherLabel.snp_makeConstraints {
            make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(authorLabel.snp_bottom).offset(4)
            make.right.lessThanOrEqualTo(scoreLabel.snp_left).offset(-10)
            
        }
        
        self.addSubview(yearLabel)
        yearLabel.snp_makeConstraints {
            make in
            make.left.equalTo(titleLabel)
            make.top.equalTo(publisherLabel.snp_bottom).offset(4)
        }
        
        self.addSubview(favBtn)
        favBtn.snp_makeConstraints {
            make in
            make.left.equalTo(yearLabel)
            make.top.equalTo(yearLabel).offset(38)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }
        
        self.addSubview(reviewBtn)
        reviewBtn.snp_makeConstraints {
            make in
            make.top.equalTo(favBtn)
            make.right.equalTo(self.snp_right).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(36)
        }
        
        
        self.addSubview(summaryTitleLabel)
        summaryTitleLabel.snp_makeConstraints {
            make in
            make.top.equalTo(favBtn.snp_bottom).offset(28)
            make.left.equalTo(favBtn)
        }
        
        self.addSubview(summaryLabel)
        summaryLabel.snp_makeConstraints {
            make in
            make.top.equalTo(summaryTitleLabel.snp_bottom).offset(20)
            make.left.equalTo(summaryTitleLabel)
            make.right.equalTo(reviewBtn)
        }
        
        self.addSubview(tapToSeeMoreBtn)
        tapToSeeMoreBtn.snp_makeConstraints {
            make in
            make.top.equalTo(summaryLabel.snp_bottom).offset(4)
            make.left.equalTo(summaryLabel)
        }
        
        self.snp_makeConstraints {
            make in
            make.width.equalTo(UIScreen.mainScreen().bounds.width)
            //make.height.equalTo(UIScreen.mainScreen().bounds.height + 100)
            make.bottom.equalTo(tapToSeeMoreBtn.snp_bottom).offset(18)
        }
    }
}

private extension UIButton {
    convenience init(title: String, borderWidth: CGFloat, borderColor: UIColor) {
        self.init()
        setTitle(title, forState: .Normal)
        setTitleColor(borderColor, forState: .Normal)
        titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        //titleLabel?.sizeToFit()
        tintColor = borderColor
        
        
        //TODO: self-sizing UIButton with Snapkit
        //        frame.size = CGSize(width: ((titleLabel?.frame.width)! + 60), height: ((titleLabel?.frame.height)! + 20))
        //        print((titleLabel?.frame.width)! + 50)
        //let titleSize = NSString(string: title).sizeWithAttributes(<#T##attrs: [String : AnyObject]?##[String : AnyObject]?#>)
        //sizeThatFits(CGSize(width: ((titleLabel?.frame.width)! + 50), height: ((titleLabel?.frame.height)! + 20)))
        self.layer.cornerRadius = 3
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
    }
}


extension CoverView: UIWebViewDelegate {
    func presentRateView() {
        let rateView = RateView(rating: 3.0, id: "\(book.id)")
        //self.addSubview(rateView)
        
        
        //        UIViewController.currentViewController().view.addSubview(rateView)
        //        rateView.snp_makeConstraints {
        //            make in
        //            make.height.equalTo(UIScreen.mainScreen().bounds.height)
        //            make.width.equalTo(UIScreen.mainScreen().bounds.width)
        //            make.top.equalTo(UIViewController.currentViewController().view)
        //            make.left.equalTo(UIViewController.currentViewController().view)
        //        }
        
        //        UIViewController.currentViewController().navigationview.addSubview(rateView)
        //UIViewController.currentViewController().navigationController?.view.addSubview(rateView)
        UIViewController.currentViewController().view.addSubview(rateView)
        //rateView.superview!.bringSubviewToFront(rateView)
        UIViewController.currentViewController().navigationItem.setHidesBackButton(true, animated: true)
        rateView.frame = CGRect(x: 0, y: self.frame.height, width: 0, height: self.frame.height/4)
        UIView.beginAnimations("ratingViewPopUp", context: nil)
        UIView.setAnimationDuration(0.6)
        rateView.frame = self.frame
        UIView.commitAnimations()
        
    }
    
    override func willRemoveSubview(subview: UIView) {
        UIViewController.currentViewController().navigationItem.setHidesBackButton(false, animated: true)
    }
    
    func favourite() {
        User.sharedInstance.addToFavourite(with: "\(self.book.id)") {
            MsgDisplay.showSuccessMsg("添加成功")
        }
        //Call `favourite` method of a user
    }
    
    func tapToSeeMore() {
        
        let blurEffect = UIBlurEffect(style: .Light)
        let frostView = UIVisualEffectView(effect: blurEffect)
        
        let doneBtn: UIButton = {
            $0.addTarget(self, action: #selector(self.tapAgainToDismiss), forControlEvents: .TouchUpInside)
            $0.setTitleColor(readRed, forState: .Normal)
            return $0
        }(UIButton(title: "完成"))
        
        
        UIViewController.currentViewController().navigationItem.setHidesBackButton(true, animated: true)
        frostView.frame = self.frame
        frostView.addSubview(doneBtn)
        doneBtn.snp_makeConstraints {
            make in
            make.left.equalTo(frostView).offset(20)
            make.top.equalTo(frostView).offset(100)
        }
        UIViewController.currentViewController().view.addSubview(frostView)
//        frostView.snp_makeConstraints {
//            make in
//            make.left.equalTo(UIViewController.currentViewController().view)
//            make.right.equalTo(UIViewController.currentViewController().view)
//            make.top.equalTo(UIViewController.currentViewController().view)
//            make.bottom.equalTo(UIViewController.currentViewController().view)
//        }
        
        let summaryDetailView = UIWebView(htmlString: book.summary)
        frostView.addSubview(summaryDetailView)
        //summaryDetailView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        summaryDetailView.snp_makeConstraints {
            make in
            make.top.equalTo(doneBtn.snp_bottom).offset(20)
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
        for fooView in (UIViewController.currentViewController().view.subviews) {
            if fooView.isKindOfClass(UIVisualEffectView) {
                UIView.animateWithDuration(0.7, animations: {
                    fooView.alpha = 0
                    }, completion: { (_) in
                        UIViewController.currentViewController().navigationItem.setHidesBackButton(false, animated: true)
                        fooView.removeFromSuperview()
                })
            }
        }
    }
}


private extension UIWebView {
    convenience init(htmlString: String) {
        self.init()
        backgroundColor = .clearColor()
        opaque = false
        userInteractionEnabled = true
        scrollView.scrollEnabled = true
        loadHTMLString(htmlString, baseURL: nil)
    }
}
