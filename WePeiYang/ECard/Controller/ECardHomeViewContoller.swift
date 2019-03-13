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
        navigationController?.navigationBar.tintColor = .eCardStandardDark
        
        /* 标题 */
        let titleLabel = UILabel(text: "校园卡")
        titleLabel.textColor = .eCardStandardDark
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
    // 校园卡标准黄 //
    static var eCardStandardDark: UIColor {
        return UIColor(hex6: 0x444444)
    }
    // 校园卡标准黄 //
    static var eCardStandardYellow: UIColor {
        return UIColor(hex6: 0xffeb86)
    }
}
