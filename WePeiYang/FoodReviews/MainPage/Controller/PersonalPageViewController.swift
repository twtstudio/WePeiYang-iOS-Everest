//
//  PersonalPageViewController.swift
//  WePeiYang
//
//  Created by 赵家琛 on 2018/5/8.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SnapKit

class PersonalPageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .yellow
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(red: 254/255, green: 119/255, blue: 11/255, alpha: 1))!, for: .default)
        //self.navigationController!.navigationBar.barTintColor = .red
        self.navigationController!.navigationBar.tintColor = .white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        self.navigationItem.title = "我的"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.resizedImage(image: UIImage(named: "btn_1back")!, scaledToSize: CGSize(width: 20, height: 20)), style: .plain, target: self, action: #selector(goBack(sender:)))
        
        //导航栏渐变色
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Metadata.Color.foodReviewsLowColor.cgColor, Metadata.Color.foodReviewsHighColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        var HEIGHT:CGFloat = 64.0
        if UIScreen.main.bounds.size.height == 812 {
            HEIGHT = 88.0
        }
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.width, height: HEIGHT)
        if let barBackground = self.navigationController?.navigationBar.subviews.first {
            barBackground.layer.addSublayer(gradientLayer)
        }
        
    }
    
    @objc func goBack(sender: UIButton) {
        self.tabBarController?.navigationController?.popViewController(animated: true)
    }
    
}
