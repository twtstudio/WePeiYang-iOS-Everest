//
//  PracticeUploadViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/8/30.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class PracticeUploadViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* 导航栏 */
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: .practiceBlue), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        /* 标题 */
        let titleLabel = UILabel(text: "我的上传")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        /* 上传信息 */
        let uploadMessageLabel = UICopyLabel()
        uploadMessageLabel.textColor = .darkGray
        
        let uploadMessage = NSMutableAttributedString(string: "上传功能暂未开放, 如有批量题目需上传分享, 请加入 QQ 群 738068756 与管理员进行联系~")
        uploadMessage.addAttribute(.foregroundColor, value: UIColor.practiceBlue, range: NSMakeRange(32, 9))
        uploadMessageLabel.attributedText = uploadMessage
        uploadMessageLabel.setFlexibleHeight(andFixedWidth: deviceWidth - 40)
        uploadMessageLabel.frame.origin = CGPoint(x: 20, y: deviceHeight / 4)
        
        self.view.addSubview(uploadMessageLabel)
        
        /* 点击加群 */
        let joinGroupButton = UIButton(frame: CGRect(x: (deviceWidth - 104) / 2, y: uploadMessageLabel.frame.maxY + 20, width: 104, height: 33))
        joinGroupButton.setPracticeBubbleButton(withTitle: "点击加群")
        joinGroupButton.addTarget(self, action: #selector(joinGroup), for: .touchUpInside)
        self.view.addSubview(joinGroupButton)
        
    }
    
    @objc func joinGroup(button: UIButton) {
        button.setBounceAnimation()
        let url = URL(string: "http://qm.qq.com/cgi-bin/qm/qr?k=4V7__yuYwYBFwh-rTvF7tQQvVhQGMoTv")
        if UIApplication.shared.canOpenURL(url!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!)
            }
        }
    }
    
}

/* 支持复制功能的 UILabel */
class UICopyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showMenu)))
    }
    
    @objc func showMenu(_ sender: UILongPressGestureRecognizer) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    // 支持复制 //
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.string = text
        let menu = UIMenuController.shared
        menu.setMenuVisible(false, animated: true)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) { return true }
        return false
    }
    
}
