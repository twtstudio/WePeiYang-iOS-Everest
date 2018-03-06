//
//  UIViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/2/24.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import WebKit

class MallViewController: ProgressWebViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.95, green:0.50, blue:0.17, alpha:1.00)
        webView.load(URLRequest(url: URL(string: "https://mall.twt.edu.cn/")!))
    }
}

extension MallViewController {
}
