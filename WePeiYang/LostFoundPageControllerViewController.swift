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
        self.init(viewControllerClasses: [LostViewController.self, FoundViewController.self], andTheirTitles: ["丢失", "捡到"])
//        self.init(viewControllerClasses: [LostViewController.self, FoundViewController.self], andTheirTitles: ["hi", "a"]）
        
        self.title = "失物招领"
        UIApplication.shared.statusBarStyle = .lightContent
        pageAnimatable = true
        menuViewStyle = .line
        titleSizeSelected = 16.0
        titleSizeNormal = 15.0
        menuHeight = 50
        titleColorSelected = UIColor(hex6: 0x00a1e9)
        titleColorNormal = UIColor(hex6: 0xc8ccd3)
        menuItemWidth = self.view.frame.size.width/2


//        menuBGColor = .white
//        progressColor = UIColor(hex6: 0x00a1e9)

    }
    
    
    //Mark --导航栏（Navigationbar）的配置
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00a1e9)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        

    }
    override func viewDidLoad() {
        menuBGColor = .white
        progressColor = UIColor(hex6: 0x00a1e9)
        
        let mine = #imageLiteral(resourceName: "Settings")
//        let search = #imageLiteral(resourceName: "AllModules")
        let mineItem = UIBarButtonItem(image: mine, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.mineButton(item:)))
//        let searchItem = UIBarButtonItem(image: search, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.mineButton(item:)))
        
        self.navigationItem.rightBarButtonItem = mineItem
        
        
        super.viewDidLoad()

    }
    func mineButton(item: UIBarButtonItem) {
        let vc = MyLostFoundPageViewController(para: 1)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
