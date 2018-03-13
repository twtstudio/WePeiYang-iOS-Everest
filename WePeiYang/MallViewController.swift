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
//        navigationController?.navigationBar.barStyle = .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mallOrange
        webView.load(URLRequest(url: URL(string: "https://mall.twt.edu.cn/")!))
        self.reloadButton.setTitleColor(UIColor(red:0.75, green:0.75, blue:0.74, alpha:1.00), for: .normal)
    }
}

extension MallViewController {
    override func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.94, alpha:1.00)
        super.webView(webView, didFailProvisionalNavigation: navigation, withError: error)
    }

    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        super.webView(webView, didFinish: navigation)
        self.view.backgroundColor = .mallOrange
    }

    override func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        super.webView(webView, didFail: navigation, withError: error)
        self.view.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.94, alpha:1.00)
    }
}

private extension UIColor {
    static var mallOrange: UIColor {
        return UIColor(red:0.95, green:0.50, blue:0.17, alpha:1.00)
    }
}
