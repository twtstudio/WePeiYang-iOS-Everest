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
//        self.init(viewControllrerClasses: [LostViewController.self, FoundViewController.self], andTheirTitles: ["hi", "a"]）
        
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
        
        let mine = #imageLiteral(resourceName: "用户")
        let search = #imageLiteral(resourceName: "右上角搜索")
        let mineButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        mineButton.setImage(mine, for: .normal)
        mineButton.addTarget(self, action: #selector(self.mineButton(item:)), for: .touchUpInside)
        let mineBarButton = UIBarButtonItem(customView: mineButton)
        
        
        
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        searchButton.setImage(search, for: .normal)
        searchButton.addTarget(self, action: #selector(self.searchButton(item:)), for: .touchUpInside)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        //按钮间隙
        let gap = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        gap.width = 20
        //用于消除右边边空隙，要不然按钮顶不到最边上
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                     action: nil)
        spacer.width = -5;
        //设置按钮
        self.navigationItem.rightBarButtonItems = [spacer, mineBarButton , gap, searchBarButton]

        
        
        super.viewDidLoad()

    }
    func mineButton(item: UIBarButtonItem) {
        let vc = MyLostFoundPageViewController(para: 1)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func searchButton(item: UIBarButtonItem) {
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
