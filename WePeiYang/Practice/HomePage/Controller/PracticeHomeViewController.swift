//
//  PracticeHomeViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/7/13.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class PracticeHomeViewController: UIViewController, UIScrollViewDelegate {
    
    let headView = HeadView()
    let userView = UserView()
    let homeView = HomeView()
    let contentScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        contentScrollView.delegate = self
        
        contentScrollView.contentSize = CGSize(width: 2 * deviceWidth, height: contentScrollView.frame.height)
        contentScrollView.contentOffset = CGPoint(x: deviceWidth, y: 0)
        
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.isPagingEnabled = true
        
        self.view.addSubview(contentScrollView)
        
        userView.frame = CGRect(x: deviceWidth, y: 0, width: deviceWidth, height: contentScrollView.frame.height)
        contentScrollView.addSubview(userView)
        
        homeView.frame = CGRect(x: 0, y: 0, width: deviceWidth, height: contentScrollView.frame.height)
        contentScrollView.addSubview(homeView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* 导航栏 */
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: .practiceBlue), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        let barHeight = (navigationController?.navigationBar.y)! + (navigationController?.navigationBar.height)!
        
        /* 标题 */
        let titleLabel = UILabel(text: "天外天刷题")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21.0)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        /* 搜索 */
        let practiceSearch = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.practiceSearch))
        navigationItem.rightBarButtonItem = practiceSearch
        
        /* 顶部视图 */
        headView.frame = CGRect(x: 0, y: -1/3, width: deviceWidth, height: 64)
        headView.userOptionButton.addTarget(self, action: #selector(optionButtonClick), for: .touchUpInside)
        headView.homeOptionButton.addTarget(self, action: #selector(optionButtonClick), for: .touchUpInside)
        self.view.addSubview(headView)

        /* 滑动视图 */
        contentScrollView.frame = CGRect(x: 0, y: headView.frame.size.height, width: deviceWidth, height: deviceHeight - barHeight - headView.frame.height)
        
    }
    
    // 点击按钮切换, 改变白色指示条位置与按钮可用状态 //
    @objc func optionButtonClick(button: UIButton) {
        UIView.animate(withDuration: 0.25) {
            var tempX = self.headView.underLine.frame.origin.x
            switch button {
            case self.headView.userOptionButton:
                tempX += deviceWidth / 2
                self.contentScrollView.contentOffset = CGPoint(x: deviceWidth, y: 0)
            case self.headView.homeOptionButton:
                tempX -= deviceWidth / 2
                self.contentScrollView.contentOffset = CGPoint(x: 0, y: 0)
            default:
                break
            }
            (self.headView.userOptionButton.isEnabled, self.headView.homeOptionButton.isEnabled) = (self.headView.homeOptionButton.isEnabled, self.headView.userOptionButton.isEnabled)
            self.headView.underLine.frame.origin.x = tempX
        }
    }
    
    // 正在滑动时, 动态改变白色指示条位置 //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headView.underLine.frame.origin.x = deviceWidth / 6 + deviceWidth / 2 * (scrollView.contentOffset.x / deviceWidth)
    }
    
    // 结束滑动时, 判断位置刷新按钮可用状态 //
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if headView.underLine.center.x < deviceWidth / 2 {
            (self.headView.userOptionButton.isEnabled, self.headView.homeOptionButton.isEnabled) = (true, false)
        } else {
            (self.headView.userOptionButton.isEnabled, self.headView.homeOptionButton.isEnabled) = (false, true)
        
        }
    }
    
    // 进入搜索界面 //
    @objc func practiceSearch() {
        
    }
    
}

extension UIColor {
    // 刷题蓝色 //
    static var practiceBlue: UIColor {
        return UIColor(red: 67.0/255.0, green: 170.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    }
}
