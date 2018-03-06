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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        title = "详情"

        view.backgroundColor = .white
        webView.frame.origin.x = 20
        webView.frame.size.width -= 40

        SolaSessionManager.solaSession(type: .get, url: "/news/\(index)", token: nil, parameters: nil, success: { dict in
            if let topModel = try? NewsDetailTopModel(data: dict.jsonData()) {
                self.news = topModel.data
                let html = self.FEProcessor(model: topModel.data, content: topModel.data.content)
                self.webView.loadHTMLString(html, baseURL: nil)
            }
        }, failure: { error in
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
        let str = "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no\"><link rel=\"stylesheet\" href=\"https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css\" integrity=\"sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u\" crossorigin=\"anonymous\"><h2 style=\"text-align: center;>\(model.subject)</h2><h3 style=\"text-align: center;\">\(model.subject)</h3><h5 style=\"text-align: left;\">阅读:\(model.visitcount)</h5>" + content +
            "<h5 style=\"text-align: left;\">供稿:\(model.gonggao)</h5><h5 style=\"text-align: left;\">审稿:\(model.shengao)</h5>" +
            sheying +
        "<h5 style=\"text-align: left;\">新闻来源:\(model.newscome)</h5>"
        return str
    }

}

extension NewsDetailViewController {
    override func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        super.webView(webView, didStartProvisionalNavigation: navigation)

//        webView.evaluateJavaScript("document.title", completionHandler: { (title, error) in
//            self.navigationItem.title = title as? String
//            })
    }
}
