//
//  LostFoundMineViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import WMPageController

class MyLostFoundPageViewController: WMPageController {

    convenience init?(para: Int) {
        
        self.init(viewControllerClasses: [MyLostViewController.self, MyFoundViewController.self], andTheirTitles: ["我丢失的","我捡到的"])
        self.title = "我的"
        UIApplication.shared.statusBarStyle = .lightContent
        pageAnimatable = true
        menuViewStyle = .line
        titleSizeSelected = 16.0
        titleSizeNormal = 15.0
        menuHeight = 50
        titleColorSelected = UIColor(hex6: 0x00a1e9)
        titleColorNormal = UIColor(hex6: 0xc8ccd3)
        menuItemWidth = self.view.frame.size.width/2
    }
    override func viewDidLoad() {

        menuBGColor = .white
        progressColor = UIColor(hex6: 0x00a1e9)
        super.viewDidLoad()
    }
}
