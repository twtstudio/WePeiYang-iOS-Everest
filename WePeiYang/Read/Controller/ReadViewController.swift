//
//  ReadViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2017/7/22.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import WMPageController

class ReadViewController: WMPageController {
    
//    init() {
//        super.init(viewControllerClasses: [RecommendedViewController.self, InfoViewController.self], andTheirTitles: ["推荐", "我的"])
//    }
//    let classes = [RecommendedViewController.self, InfoViewController.self]
    let readTitles = ["推荐", "我的"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        pageAnimatable = true
        titleSizeNormal = 15
        titleSizeSelected = 16
        menuViewStyle = .line
        titleColorSelected = .readRed
        titleColorNormal = .gray
        menuItemWidth = self.view.width/2
        
        bounces = true
        menuHeight = 44
        
        menuViewBottomSpace = -(self.menuHeight + 64.0)
        
        menuBGColor = .init(colorLiteralRed: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
        progressColor = .readRed
        progressHeight = 3.0
        
        let item = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(pushSearchViewController))
        self.navigationItem.rightBarButtonItem = item
        // Do any additional setup after loading the view.
    }
    
    func pushSearchViewController() {
        let svc = SearchViewController()
        svc.view.bounds = self.view.bounds
        self.navigationController?.pushViewController(svc, animated: true)
    }

    override func numbersOfChildControllers(in pageController: WMPageController) -> Int {
        return readTitles.count
    }
    
    override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
        return readTitles[index]
    }
    
    override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
        if index == 0 {
            return RecommendedViewController()
        } else {
            return InfoViewController()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }
}
