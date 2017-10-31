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
    
//    var data: [(title: String, viewController: UIViewController)] {
//        return [("我丢失的", MyLostViewController()), ("我捡到的", MyFoundViewController())]
//    }
//    override func numbersOfTitles(in menu: WMMenuView!) -> Int {
//        return data.count
//    }
//    override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
//        return data[index].title
//    }
//    override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
//        return data[index].viewController
//    }
    
    override func viewDidLoad() {
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
        menuBGColor = .white
        progressColor = UIColor(hex6: 0x00a1e9)
//        self.dataSource = self
        self.viewControllerClasses = [MyLostViewController.self, MyFoundViewController.self]
        self.titles = ["我丢失的", "我捡到的"]
        super.viewDidLoad()
    }
}
