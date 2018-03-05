//
//  NewsDetailViewController.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/5.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit

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
        SolaSessionManager.solaSession(type: .get, url: "/news/\(index)", token: nil, parameters: nil, success: { dict in
            if let topModel = try? NewsDetailTopModel(data: dict.jsonData()) {
                self.news = topModel.data
                self.webView.loadHTMLString(topModel.data.content, baseURL: nil)
            }
        }, failure: { error in
            // TODO: tap reload
            SwiftMessages.showErrorMessage(body: error.localizedDescription)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
