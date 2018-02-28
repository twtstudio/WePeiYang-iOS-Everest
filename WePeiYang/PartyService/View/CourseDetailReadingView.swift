//
//  CourseDetailReadingView.swift
//  WePeiYang
//
//  Created by Allen X on 8/17/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit

class CourseDetailReadingView: UIView, UIWebViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @objc func dismissAnimated() {
        //log.word("haha")/
        UIView.animate(withDuration: 0.7, animations: {
            self.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: self.frame.height)
        }, completion: { (_: Bool) in

                self.removeFromSuperview()
        }) 

    }

}

extension CourseDetailReadingView {
    convenience init(detail: Courses.Study20.Detail) {
        
        let blurEffect = UIBlurEffect(style: .light)
        let frostView = UIVisualEffectView(effect: blurEffect)
        let downArrow = UIButton(backgroundImageName: "ic_arrow_down", desiredSize: CGSize(width: 88, height: 24))
        downArrow?.alpha = 0.25
        
        self.init()
        //self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        assignGestureRecognizerToView()
        downArrow?.addTarget(self, action: #selector(self.dismissAnimated), for: .touchUpInside)
        
        self.addSubview(frostView)
        frostView.snp.makeConstraints {
            make in
            make.top.left.bottom.right.equalTo(self)
        }
        
        frostView.addSubview(downArrow!)
        downArrow!.snp.makeConstraints {
            make in
            make.top.equalTo(frostView).offset(28)
            make.centerX.equalTo(frostView)
            
        }
        
        if detail.articleIsHidden == "1" {
            let bannedLabel = UILabel(text: "你暂时没有权限阅读这篇文章", fontSize: 24)
            frostView.addSubview(bannedLabel)
            bannedLabel.snp.makeConstraints {
                make in
                make.centerX.equalTo(frostView)
                make.centerY.equalTo(frostView)
            }
        } else if detail.articleIsDeleted == "1"{
            let deletedLabel = UILabel(text: "这篇文章好像被删除啦！", fontSize: 24)
            frostView.addSubview(deletedLabel)
            deletedLabel.snp.makeConstraints {
                make in
                make.centerX.equalTo(frostView)
                make.centerY.equalTo(frostView)
            }
        } else {
            let nameLabel = UILabel(text: detail.articleName!, fontSize: 30)
            nameLabel.numberOfLines = 0
            
            //let contentView = UIWebView(htmlString: "<p><object classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0\" height=\"600\" width=\"800\"><param name=\"quality\" value=\"high\" /><param name=\"movie\" value=\"http://www.tudou.com/a/Rcd1Bo1-qqw/&iid=132528954&rpid=849459437&resourceId=849459437_04_0_99/v.swf\" /><embed height=\"600\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" quality=\"high\" src=\"http://www.tudou.com/a/Rcd1Bo1-qqw/&iid=132528954&rpid=849459437&resourceId=849459437_04_0_99/v.swf\" type=\"application/x-shockwave-flash\" width=\"800\"></embed></object></p>")
            let contentView = UIWebView(htmlString: detail.articleContent!)
            contentView.delegate = self
            
            let timeLabel = UILabel(text: detail.courseInsertTime!, fontSize:13)
            timeLabel.textColor = .gray
            
            frostView.addSubview(nameLabel)
            nameLabel.snp.makeConstraints {
                make in
                make.left.equalTo(frostView).offset(24)
                make.top.equalTo(downArrow!).offset(26)
                make.right.equalTo(frostView).offset(-28)
            }
            
            frostView.addSubview(timeLabel)
            timeLabel.snp.makeConstraints {
                make in
                make.left.equalTo(nameLabel)
                make.top.equalTo(nameLabel.snp.bottom).offset(14)
            }
            
            frostView.addSubview(contentView)
            contentView.snp.makeConstraints {
                make in
                make.left.equalTo(frostView).offset(18)
                make.top.equalTo(timeLabel.snp.bottom).offset(8)
                make.right.equalTo(frostView).offset(-20)
                make.bottom.equalTo(frostView)
                
            }
        }
    }
}

//Gesture Recognizer
private extension CourseDetailReadingView {

    func assignGestureRecognizerToView() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissAnimated))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
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
