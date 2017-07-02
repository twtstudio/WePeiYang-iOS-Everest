//
//  LostFoundPageViewController.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/2.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import WMPageController

class LostFoundPageViewController: WMPageController {

    convenience init?(para: Int) {
        self.init(viewControllerClasses: [LostViewController.self, FoundViewController.self], andTheirTitles: ["丢失", "找到"])
//        self.init(viewControllerClasses: [LostViewController.self, FoundViewController.self], andTheirTitles: ["hi", "a"]）
        
        self.title = "失物招领"
        UIApplication.shared.statusBarStyle = .lightContent
        pageAnimatable = true
        titleSizeSelected = 16.0
        titleSizeNormal = 15.0
        menuHeight = 36
        
        

    }
        

}
