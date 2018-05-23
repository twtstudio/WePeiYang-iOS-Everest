//
//  HomePageTabBarController.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/5/8.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class MainPageTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainPageVC = FoodReviewsMainViewControloler()
        mainPageVC.tabBarItem = UITabBarItem(title: "首页", image: self.preventSystemColoring(img: UIImage(named: "btn_3首页_n")!), selectedImage: self.preventSystemColoring(img: UIImage(named: "btn_3首页_s")!))
        let mainPageNavigationController = UINavigationController(rootViewController: mainPageVC)
        
        let personalPageVC = PersonalPageViewController()
        personalPageVC.tabBarItem = UITabBarItem(title: "我的", image: self.preventSystemColoring(img: UIImage(named: "个人中心_n")!), selectedImage: self.preventSystemColoring(img: UIImage(named: "个人中心_s")!))
        let personnalPageNavigationController = UINavigationController(rootViewController: personalPageVC)
        
        
        self.setViewControllers([mainPageNavigationController, personnalPageNavigationController], animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UITabBar.appearance().tintColor = Metadata.Color.foodReviewsLowColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UITabBar.appearance().tintColor = Metadata.Color.WPYAccentColor
    }
    
}

extension MainPageTabBarController {
    
    func preventSystemColoring(img :UIImage) -> UIImage {
        return UIImage.resizedImage(image: img, scaledToSize: CGSize(width: 23, height: 23)).withRenderingMode(.alwaysOriginal)
    }
    
}
