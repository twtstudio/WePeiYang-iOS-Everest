//
//  ECardHomeViewContoller.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2019/3/13.
//  Copyright © 2019年 twtstudio. All rights reserved.
//

import UIKit

class ECardHomeViewContoller: UIViewController {
    
    /* 首页视图 */
    let homeTableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* 导航栏 */
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: .eCardStandardYellow), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .eCardDark
        
        /* 标题 */
        let titleLabel = UILabel(text: "校园卡")
        titleLabel.textColor = .eCardDark
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        /* 返回 */
        let eCardBack = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = eCardBack
        
        /* 刷新 */
        let eCardRefresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.eCardRefresh))
        navigationItem.rightBarButtonItem = eCardRefresh
    }
    
    // 刷新 //
    @objc func eCardRefresh() {
        
    }
    
}

extension UIColor {
    // 校园卡标准深黑 //
    static var eCardBlack: UIColor {
        return UIColor(hex6: 0x222222)
    }
    // 校园卡标准黑 //
    static var eCardDark: UIColor {
        return UIColor(hex6: 0x444444)
    }
    // 校园卡标准灰 //
    static var eCardGray: UIColor {
        return UIColor(hex6: 0x666666)
    }
    // 校园卡标准浅灰 //
    static var eCardLightGray: UIColor {
        return UIColor(hex6: 0x7a7a7a)
    }
    // 校园卡标准黄 //
    static var eCardStandardYellow: UIColor {
        return UIColor(hex6: 0xffeb86)
    }
}
