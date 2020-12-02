//
//  FBRateCommentView.swift
//  WePeiYang
//
//  Created by Zrzz on 2020/11/29.
//  Copyright © 2020 twtstudio. All rights reserved.
//

import UIKit

class FBRateCommentView: MessageView {
    private var starRateView: FBStarRateView!
    private var commentTextView: UITextView!
    
    private var score: Float = 0
    
    var successHandler: (() -> Void)?
    var failureHandler: (() -> Void)?
    
    init() {
        super.init(frame: CGRect(x: 30, y: UIScreen.main.bounds.height*0.2, width: UIScreen.main.bounds.width-60, height: 300))
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let contentView = UIView()
        contentView.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1.00)
        self.backgroundColor = .clear
        installBackgroundView(contentView)
        configureBackgroundView(width: 250)
        contentView.snp.makeConstraints { make in
            if isiPad {
                make.top.equalToSuperview().offset(30)
                make.bottom.equalToSuperview().offset(-30)
                make.width.equalToSuperview().multipliedBy(0.6)
                make.left.equalTo(deviceWidth*0.2)
                make.right.equalTo(-deviceWidth*0.2)
            } else {
                make.top.left.equalToSuperview().offset(30)
                make.bottom.right.equalToSuperview().offset(-30)
                make.width.equalTo(250)
            }
            make.height.equalTo(300)
        }
        
        titleLabel = UILabel()
        titleLabel?.text = "评价回复"
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        titleLabel?.sizeToFit()
        contentView.addSubview(titleLabel!)
        titleLabel?.snp.makeConstraints({ (make) in
            make.top.centerX.equalToSuperview()
        })
        
        starRateView = FBStarRateView(frame: CGRect(origin: .zero, size: CGSize(width: 170, height: 30)), progressImg: UIImage(named: "feedback_star_fill"), trackImg: UIImage(named: "feedback_star"))
        starRateView.show(type: .half, isInteractable: true, leastStar: 0) { (score) in
            self.score = Float(score)
            print(score)
        }
        contentView.addSubview(starRateView)
        starRateView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel!.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(30)
        }
        
        commentTextView = UITextView()
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor(hex6: 0xf4f4f4).cgColor
        commentTextView.layer.cornerRadius = 5
        commentTextView.layer.masksToBounds = true
        commentTextView.textContainerInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 5)
        commentTextView.font = .systemFont(ofSize: 14)
        contentView.addSubview(commentTextView)
        commentTextView.snp.makeConstraints { (make) in
            make.top.equalTo(starRateView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        button = UIButton()
        button?.backgroundColor = UIColor.feedBackBlue
        button?.addTarget(self, action: #selector(rateComment), for: .touchUpInside)
        button?.setTitle("确认提交", for: .normal)
        button?.layer.cornerRadius = 15
        button?.layer.masksToBounds = true
        contentView.addSubview(button!)
        button?.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(commentTextView.snp.bottom).offset(15)
            make.height.equalTo(35)
            make.width.equalTo(100)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        backgroundView.layer.cornerRadius = 10
    }
    
    @objc private func rateComment() {
        if score == 0 || commentTextView.text.isEmpty {
            let alert = UIAlertController(title: "提示", message: "信息未补充完整", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "好的", style: .default, handler: nil)
            alert.addAction(action1)
            // for iPad
            if let popover = alert.popoverPresentationController {
                popover.sourceView = button
                popover.sourceRect = button?.frame ?? CGRect(x: 0, y: 0, width: 1, height: 1)
                popover.permittedArrowDirections = .any
            }
            var topVC = UIApplication.shared.keyWindow?.rootViewController
            while((topVC!.presentedViewController) != nil) {
                topVC = topVC!.presentedViewController
            }
            topVC?.present(alert, animated: true)
        } else {
            SwiftMessages.showLoading()
            FBCommentHelper.commentAnswer(answerId: TwTUser.shared.feedbackID ?? 0, score: Int(score * 2), commit: commentTextView.text) { (result) in
                switch result {
                    case .success(_):
                        SwiftMessages.showSuccessMessage(body: "评价成功！")
                    case .failure(let err):
                        print("<FBRateCommentView>CommentAnswer ERROR!\n" + err.localizedDescription)
                }
                SwiftMessages.hideLoading()
                SwiftMessages.hideAll()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension FBRateCommentView {
    @objc func keyboardWillShow(notification: Notification) {
        if isiPad {
            return
        }
        self.frame.origin.y = 20
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.frame.origin.y = (UIScreen.main.bounds.height - self.frame.height)/2
    }
}
