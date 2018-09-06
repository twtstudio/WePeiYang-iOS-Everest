//
//  BicycleNotificationDetailViewController.swift
//  WePeiYang
//
//  Created by JinHongxu on 16/8/10.
//  Copyright © 2016年 Qin Yubo. All rights reserved.
//

import Foundation
import UIKit

class BicycleNotificationDetailViewController: UIViewController {

    @IBOutlet var contentWebView: UIWebView!

    var notificationTitle: String?
    var notificationContent: String?
    var time: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard time != nil, notificationTitle != nil, notificationContent != nil else {
            fatalError("请给这三个变量传值")
        }

        contentWebView.scrollView.bounces = false
//        self.view.frame.size.width = (UIApplication.shared.keyWindow?.frame.size.width)!

        //NavigationBar 的文字
        self.navigationController!.navigationBar.tintColor = .white

        //NavigationBar 的背景，使用了View
        //self.navigationController!.jz_navigationBarBackgroundAlpha = 0;
//        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.navigationController!.navigationBar.frame.size.height+UIApplication.shared.statusBarFrame.size.height))

//        bgView.backgroundColor = UIColor(red: 0.0/255.0, green: 174.0/255.0, blue: 101.0/255.0, alpha: 1.0)
//        self.view.addSubview(bgView)

        //改变 statusBar 颜色

//        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        let titleLabel = UILabel.init(frame: CGRect.zero)
        titleLabel.backgroundColor = .clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = .white
        navigationItem.titleView = titleLabel
        titleLabel.text = "通知公告"
        titleLabel.sizeToFit()

        //加载HTMLString
        self.contentWebView.loadHTMLString(self.renderHTMLWithTitle(title: notificationTitle!, content: notificationContent!, time: time!), baseURL: URL.init(fileURLWithPath: Bundle.main.resourcePath!))
    }

    func renderHTMLWithTitle(title: String, content: String, time: String) -> String {
        let load = "<!DOCTYPE html> \n <html> \n <head> \n <meta charset=\"utf-8\"> \n <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"> \n <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> \n <link href=\"bootstrap.css\" rel=\"stylesheet\"> \n </head> \n <body> \n <div class=\"container\"> \n <div class=\"row\"> \n <div class=\"col-sm-12\" style=\"font-size: 16px;\"> \n <h3>\(title)</h3> \n <br> \n \(content) \n <br><br> \n </div> \n <div class=\"col-sm-12\" style=\"color: #666666; font-size: 16px;\">\(time)</div> \n </div></div> \n <script src=\"bootstrap.min.js\"></script> \n <script src=\"jquery.min.js\"></script> \n <script src=\"bridge.js\"></script> \n </body> \n </html>"

        return load
    }
}
