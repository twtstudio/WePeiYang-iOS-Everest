//
//  ProgressWebViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/5.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import WebKit

class ProgressWebViewController: UIViewController {
    var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    var progressView = UIProgressView()

    func setupWebView() {
//        webView = WKWebView(frame: self.view.bounds, configuration: config)
        webView.frame = self.view.bounds
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .init(rawValue: 0), context: nil)
        self.view.addSubview(webView)
        webView.navigationDelegate = self
    }

    func setupProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 5)
        progressView.trackTintColor = .white
        progressView.progressTintColor = .readRed

        self.view.addSubview(progressView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        setupProgressView()
    }
}

extension ProgressWebViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress",
            let object = object as? WKWebView,
            object == webView {
            progressView.alpha = 1.0
            let animated = Float(webView.estimatedProgress) > progressView.progress
            progressView.setProgress(Float(webView.estimatedProgress), animated: animated)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { finished in
                    self.progressView.setProgress(0, animated: false)
                })
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension ProgressWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false

//        webView.evaluateJavaScript("document.title") { title, error in
//            if let title = title as? String {
//                self.title = title
//            }
//        }
    }
}
