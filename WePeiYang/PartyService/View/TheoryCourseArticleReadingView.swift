//
//  TheoryCourseArticleReadingView.swift
//  WePeiYang
//
//  Created by Allen X on 8/17/16.
//  Copyright © 2016 Qin Yubo. All rights reserved.
//

import UIKit
import WebKit

class TheoryCourseArticleReadingView: UIView {

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    @objc func dismissAnimated() {
        UIView.animate(withDuration: 0.7, animations: {
            self.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width/4, height: self.frame.height/2)
        }, completion: { (_: Bool) in
            self.removeFromSuperview()
        })

    }

}

extension TheoryCourseArticleReadingView {
    convenience init(article: Courses.StudyText.Article) {

        let blurEffect = UIBlurEffect(style: .light)
        let frostView = UIVisualEffectView(effect: blurEffect)
        self.init()
        //self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        assignGestureRecognizerToView()

        self.addSubview(frostView)
        frostView.snp.makeConstraints {
            make in
            make.top.left.bottom.right.equalTo(self)
        }

        if article.fileIsDeleted == "1" {
            let deletedLabel = UILabel(text: "这篇文章好像被删除啦！", fontSize: 24)
            frostView.addSubview(deletedLabel)
            deletedLabel.snp.makeConstraints {
                make in
                make.centerX.equalTo(frostView)
                make.centerY.equalTo(frostView)
            }
        } else {
            let nameLabel = UILabel(text: article.fileTitle!, fontSize: 30)
            nameLabel.numberOfLines = 0

            let timeLabel = UILabel(text: article.fileAddTime!, fontSize: 13)
            timeLabel.textColor = .gray

            frostView.addSubview(nameLabel)
            nameLabel.snp.makeConstraints {
                make in
                make.left.equalTo(frostView).offset(24)
                make.top.equalTo(frostView).offset(30)
                make.right.equalTo(frostView).offset(-28)
            }

            frostView.addSubview(timeLabel)
            timeLabel.snp.makeConstraints {
                make in
                make.left.equalTo(nameLabel)
                make.top.equalTo(nameLabel.snp.bottom).offset(14)
            }
        }

        if article.fileType == "7" {

        }

    }
}

//Gesture Recognizer
private extension TheoryCourseArticleReadingView {

    func assignGestureRecognizerToView() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissAnimated))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }

}

private extension WKWebView {
    convenience init(htmlString: String) {
        self.init()
        backgroundColor = .clear
        isOpaque = false
        isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        loadHTMLString(htmlString, baseURL: nil)
    }
}
