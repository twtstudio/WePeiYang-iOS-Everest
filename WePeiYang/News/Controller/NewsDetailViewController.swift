//
//  NewsDetailViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/5.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailViewController: ProgressWebViewController {
    var index: String
    var news: NewsDetailModel?

    init(index: String) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: .white), for: .default)
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        // 因为这个方法不会取消左滑back手势
//        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.frame.origin.y = navigationController?.navigationBar.height ?? webView.frame.origin.y
        webView.height -= 10
        title = "详情"

        if #available(iOS 10.0, *) {
            webView.scrollView.refreshControl = nil
        }

        view.backgroundColor = .white
//        webView.frame.origin.x = 20
//        webView.frame.size.width -= 40

        // 不显示竖直的滚动条
//        for subview in webView.subviews {
//            if let scrollView = subview as? UIScrollView {
//                scrollView.showsVerticalScrollIndicator = false
//            }
//        }
        self.navigationController?.hidesBarsOnSwipe = true

        SwiftMessages.showLoading()
        SolaSessionManager.solaSession(type: .get, url: "/news/\(index)", token: nil, parameters: nil, success: { dict in
            SwiftMessages.hideLoading()
            if let topModel = try? NewsDetailTopModel(data: dict.jsonData()) {
                self.news = topModel.data
                let html = self.FEProcessor(model: topModel.data, content: topModel.data.content)
                self.webView.loadHTMLString(html, baseURL: nil)
            }
        }, failure: { error in
            SwiftMessages.hideLoading()
            // TODO: tap reload
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })
    }

    func FEProcessor(model: NewsDetailModel, content: String) -> String {
        var sheying = "<h5 style=\"text-align: right;\">摄影:"
        if model.sheying != "" {
            sheying += "\(model.sheying)</h5>"
        }
        else{
            sheying = ""
        }
        let str = "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no\"><link rel=\"stylesheet\" href=\"https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css\" integrity=\"sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u\" crossorigin=\"anonymous\"><body style=\"padding: 10px 15px;\"><h2 style=\"text-align: center;>\(model.subject)</h2><h3 style=\"text-align: center;\">\(model.subject)</h3><h5 style=\"text-align: left;\">阅读:\(model.visitcount)</h5>" + content +
            "<h5 style=\"text-align: left;\">供稿:\(model.gonggao)</h5><h5 style=\"text-align: left;\">审稿:\(model.shengao)</h5>" +
            (model.sheying == "" ? "" :
            "<h5 style=\"text-align: left;\">摄影:\(model.sheying)</h5></body>") +
        "<h5 style=\"text-align: left;\">新闻来源:\(model.newscome)</h5></body>"
        return str
    }
}

extension NewsDetailViewController {
//    override func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        super.webView(webView, didStartProvisionalNavigation: navigation)
//
////        webView.evaluateJavaScript("document.title", completionHandler: { (title, error) in
////            self.navigationItem.title = title as? String
////            })
//    }
}
