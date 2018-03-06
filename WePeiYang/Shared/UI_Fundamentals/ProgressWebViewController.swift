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
    var webView: WKWebView!
    var progressView = UIProgressView()
    var backBarButtonItem: UIBarButtonItem!
    var closeBarButtonItem: UIBarButtonItem!
    var canDownRefresh: Bool = true
    var popGestureRecognizerDelegate: UIGestureRecognizerDelegate?
    let refreshControl = UIRefreshControl()
    var reloadButton: UIButton!

    func setupReloadButton() {
        reloadButton = UIButton(type: .custom)
        reloadButton.frame = CGRect(x: 0, y: 0, width: 167, height: 106)

        reloadButton.center = self.view.center
//        reloadButton.layer.cornerRadius = 75
        reloadButton.setBackgroundImage(UIImage(named: "noNetwork"), for: .normal)
        reloadButton.addTarget(self, action: #selector(reloadWebView), for: .touchUpInside)
        reloadButton.setTitle("网络错误\n点击重试", for: .normal)
        reloadButton.setTitleColor(.lightGray, for: .normal)
        reloadButton.titleEdgeInsets = .init(top: 200, left: -50, bottom: 0, right: -50)
        reloadButton.titleLabel?.numberOfLines = 0
        reloadButton.titleLabel?.textAlignment = .center
        reloadButton.frame.origin.y -= 100
    }

    func setupWebView() {
        let config = WKWebViewConfiguration()
        config.allowsPictureInPictureMediaPlayback = true
        webView = WKWebView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.width, height: self.view.height-UIApplication.shared.statusBarFrame.height), configuration: config)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .init(rawValue: 0), context: nil)
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        if #available(iOS 10.0, *), canDownRefresh {
            refreshControl.addTarget(self, action: #selector(reloadWebView), for: .valueChanged)
            webView.scrollView.refreshControl = refreshControl
        }

        setupReloadButton()
        self.view.addSubview(reloadButton)
        self.view.addSubview(webView)
    }

    func setupProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 5)
        progressView.trackTintColor = .white
        progressView.progressTintColor = .readRed

        self.view.addSubview(progressView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (self.navigationController?.viewControllers.count ?? 0) > 1 {
            self.popGestureRecognizerDelegate = self.navigationController?.interactivePopGestureRecognizer?.delegate
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self.popGestureRecognizerDelegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        hidesBottomBarWhenPushed = true
        self.navigationController?.navigationBar.isTranslucent = true

        backBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(goBack(item:)))
        closeBarButtonItem = UIBarButtonItem(title: "关闭", style: .done, target: self, action: #selector(close(item:)))

        setupWebView()
        setupProgressView()
        showLeftBarButtonItem()
    }

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.stopLoading()
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
    }
}

extension ProgressWebViewController {
    @objc func reloadWebView() {
        webView.reload()
    }

    @objc func goBack(item: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func close(item: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    func showLeftBarButtonItem() {
        if webView.canGoBack {
            self.navigationItem.leftBarButtonItems = [backBarButtonItem, closeBarButtonItem]
        } else {
            self.navigationItem.leftBarButtonItem = backBarButtonItem
        }
    }

    // 进度条
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress",
            let object = object as? WKWebView,
            object == webView {
            progressView.alpha = 1.0
            let animated = Float(webView.estimatedProgress) > progressView.progress
            progressView.setProgress(Float(webView.estimatedProgress), animated: animated)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
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
        webView.isHidden = false
        progressView.isHidden = false
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
        showLeftBarButtonItem()
        refreshControl.endRefreshing()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        webView.isHidden = true
//        reloadButton.setTitle(error.localizedDescription, for: .normal)
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.isHidden = true
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webView.isHidden = true
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {

    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.previousFailureCount == 0 {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                let credential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, credential)
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        decisionHandler(.allow)
    }
}

extension ProgressWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//        if let isMainFrame = navigationAction.targetFrame?.isMainFrame,
//            !isMainFrame {
            webView.load(navigationAction.request)
//        }
        return nil
    }
}

extension ProgressWebViewController: UIGestureRecognizerDelegate {
    

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (self.navigationController?.viewControllers.count ?? 0) > 1
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (self.navigationController?.viewControllers.count ?? 0) > 1
    }
}
