//
//  PracticeHomeViewController.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/7/13.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

class PracticeHomeViewController: UIViewController {
    
    let headView = HeadView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: deviceHeight/4))
    let userView = UserView(frame: CGRect(x: 0, y: deviceHeight/4, width: deviceWidth, height: deviceHeight*3/4))
    let homeView = HomeView(frame: CGRect(x: -deviceWidth, y: deviceHeight/4, width: deviceWidth, height: deviceHeight*3/4))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.view.addSubview(headView)
        self.view.addSubview(userView)
        self.view.addSubview(homeView)
        headView.userOptionButton.addTarget(self, action: #selector(optionButtonClick), for: .touchUpInside)
        headView.homeOptionButton.addTarget(self, action: #selector(optionButtonClick), for: .touchUpInside)
    }
    
    // 切换事件
    @objc func optionButtonClick(button: UIButton) {
        UIView.animate(withDuration: 0.25) {
            var tempFrame = self.headView.underLine.frame
            switch button {
            case self.headView.userOptionButton:
                tempFrame.origin.x += deviceWidth*2/5
                self.userView.frame.origin.x -= deviceWidth
                self.homeView.frame.origin.x -= deviceWidth
                (self.headView.userOptionButton.isEnabled, self.headView.homeOptionButton.isEnabled) = (self.headView.homeOptionButton.isEnabled, self.headView.userOptionButton.isEnabled)
            case self.headView.homeOptionButton:
                tempFrame.origin.x -= deviceWidth*2/5
                self.userView.frame.origin.x += deviceWidth
                self.homeView.frame.origin.x += deviceWidth
                (self.headView.userOptionButton.isEnabled, self.headView.homeOptionButton.isEnabled) = (self.headView.homeOptionButton.isEnabled, self.headView.userOptionButton.isEnabled)
            default:
                break
            }
            self.headView.underLine.frame = tempFrame
        }
    }
    
}
