//
//  BicycleServiceViewController.swift
//  WePeiYang
//
//  Created by Tigris on 31/08/2017.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit
import WMPageController
import PopupDialog

class BicycleServiceViewController: WMPageController {
    var titleLabel: UILabel!
    var mapIconImageView: UIImageView!
    var infoIconImageView: UIImageView!
    var notificationIconImageView: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // text color of NavigationBar
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(red: 0.0 / 255.0, green: 174.0 / 255.0, blue: 101.0 / 255.0, alpha: 1.0)) ?? UIImage(), for: .default)
//        navigationController?.navigationBar.barTintColor = UIColor(red: 0.0 / 255.0, green: 174.0 / 255.0, blue: 101.0 / 255.0, alpha: 1.0)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(red: 0.0 / 255.0, green: 174.0 / 255.0, blue: 101.0 / 255.0, alpha: 1.0)), for: .default)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        // addIcon
        self.addIcons()
    }

    override func viewDidLoad() {
        navigationController?.navigationBar.barStyle = .black

//        UIApplication.shared.statusBarStyle = .lightContent

        menuBGColor = UIColor(red: 0.0 / 255.0, green: 174.0 / 255.0, blue: 101.0 / 255.0, alpha: 1.0)
        progressColor = UIColor(red: 69.0 / 255.0, green: 216.0 / 255.0, blue: 146 / 255.0, alpha: 1.0)
        progressHeight = 3.0

        titleLabel = UILabel.init(frame: CGRect.zero)
        titleLabel.backgroundColor = .clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = .white
        navigationItem.titleView = self.titleLabel
        titleLabel.text = "地图"
        titleLabel.sizeToFit()

        self.title = "自行车"
        UIApplication.shared.statusBarStyle = .lightContent

        pageAnimatable = true
        titleSizeSelected = 18.0
        titleSizeNormal = 15.0
        menuViewStyle = WMMenuViewStyle.line
        titleColorSelected = .white
        titleColorNormal = .darkGray
        menuItemWidth = self.view.frame.size.width / 3

        bounces = true
        menuHeight = 44
        menuViewBottomSpace = -(self.menuHeight + 64.0)

        // didAddIcon

        viewControllerClasses = [BicycleServiceMapController.self, BicycleServiceInfoController.self, BicycleServiceNotificationController.self]
        titles = ["", "", ""]

        // 消除辣鸡分割线
        if let bgView = self.navigationController?.navigationBar.subviews.first {
            for view in bgView.subviews where view.height <= 1 {
                view.isHidden = true
            }
        }

        hidesBottomBarWhenPushed = true

        BicycleUser.sharedInstance.auth(success: {})
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillDisappear(animated)
//        UIApplication.shared.statusBarStyle = .default
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }

    func addIcons() {
        let iconWidth: CGFloat = 30
        let iconHeight: CGFloat = 30
        let x: CGFloat = self.view.frame.size.width / 6 - iconWidth / 2
        let y: CGFloat = self.menuHeight / 2 - iconHeight / 2
        // height of status bar = 20, height of navigationBar = 44

        self.mapIconImageView = UIImageView(frame: CGRect(x: x, y: y, width: iconWidth, height: iconHeight))
        self.mapIconImageView.image = UIImage(named: "地图")
        self.infoIconImageView = UIImageView(frame: CGRect(x: x + self.menuItemWidth, y: y, width: iconWidth, height: iconHeight))
        self.infoIconImageView.image = UIImage(named: "信息")
        self.notificationIconImageView = UIImageView(frame: CGRect(x: x + 2 * self.menuItemWidth, y: y, width: iconWidth, height: iconHeight))
        self.notificationIconImageView.image = UIImage(named: "公告")

        self.view.addSubview(self.mapIconImageView)
        self.view.addSubview(self.infoIconImageView)
        self.view.addSubview(self.notificationIconImageView)
    }

    func changeNotificationIcon() {
        if NotificationList.sharedInstance.didGetNewNotification {
            self.notificationIconImageView.image = UIImage(named: "公告2")
        } else {
            self.notificationIconImageView.image = UIImage(named: "公告")
        }
    }

    func changeIconImageView(imageView: UIImageView, width: CGFloat) {
        if imageView.frame.size.width == width {
            return
        }

        let changeWidth: CGFloat = width - imageView.frame.size.width

        UIView.animate(withDuration: 0.3, animations: {
            imageView.frame = CGRect(x: imageView.frame.origin.x - changeWidth / 2, y: imageView.frame.origin.y - changeWidth / 2, width: width, height: width)
        })
    }

    override func pageController(_ pageController: WMPageController, didEnter viewController: UIViewController, withInfo info: [AnyHashable: Any]) {
        if info["index"] as? Int == 0 {
            self.titleLabel.text = "地图"
            self.navigationItem.rightBarButtonItem = nil
        } else if info["index"] as? Int == 1 {
            self.titleLabel.text = "信息"

            let refreshButton = UIBarButtonItem.init(barButtonSystemItem: .refresh, target: self, action: #selector(refreshUserInfo))
            self.navigationItem.rightBarButtonItem = refreshButton

            if TwTUser.shared.bicycleBindingState == false {
                // FIXME: 从“好的”进入 bindingVC 后“暂不绑定” tabBar 会消失
                let popup = PopupDialog(title: "请先绑定自行车账号", message: "没有绑定账号，请先绑定账号。", image: nil, buttonAlignment: .horizontal, gestureDismissal: false, hideStatusBar: false, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
                let cancelButton = CancelButton(title: "取消", action: {
                    self.navigationController?.popViewController(animated: true)
                })
                let okButton = DefaultButton(title: "好的", action: {
                    let bindVC = BicycleBindingViewController()
                    self.present(bindVC, animated: true, completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                })
                popup.addButtons([cancelButton, okButton])
                self.present(popup, animated: true, completion: nil)
            }
//            refreshUserInfo()
        } else {
            self.titleLabel.text = "公告"
            self.navigationItem.rightBarButtonItem = nil

            NotificationList.sharedInstance.didGetNewNotification = false
            self.notificationIconImageView.image = UIImage(named: "公告")
        }
    }

    @objc func refreshUserInfo() {
        let infoVC: BicycleServiceInfoController = self.currentViewController as! BicycleServiceInfoController
        infoVC.refreshInfo()
    }
}
