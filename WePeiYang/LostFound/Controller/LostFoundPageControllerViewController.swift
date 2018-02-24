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

//    var data: [(title: String, viewController: UIViewController)] {
//        return [("丢失", LostViewController()), ("捡到", FoundViewController())]
//    }
    
    //Mark --导航栏（Navigationbar）的配置
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(hex6: 0x00a1e9))!, for: .default)
//        self.navigationController?.navigationBar.barTintColor = UIColor(hex6: 0x00a1e9)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    override func viewDidLoad() {
        
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

        let fab = FAB(subActions: [
            (name: "fuck", function: {
                
                let vc = PublishLostViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            (name: "fs", function: {
                
                let vc = PublishLostViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                
            })
            ])
        
        
            fab.showUp()
        
//        self.dataSource = self
        self.viewControllerClasses = [LostViewController.self, FoundViewController.self]
        self.titles = ["丢失", "捡到"]
        super.viewDidLoad()

    }
    
    @objc func mineButton(item: UIBarButtonItem) {
        let vc = MyLostFoundPageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func searchButton(item: UIBarButtonItem) {
        let vc = LostFoundSearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
//        let successVC = PublishSuccessViewController()
//        self.navigationController?.pushViewController(successVC, animated: true)
    }
    
//    override func numbersOfTitles(in menu: WMMenuView!) -> Int {
//        return data.count
//    }
//    override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
//        return data[index].title
//    }
//    override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
//        return data[index].viewController
//    }
}
