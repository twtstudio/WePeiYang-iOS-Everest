//
//  HomePageHelper.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/1.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

struct HomePageHelper {
    static func getHomepage(success: @escaping (HomePageTopModel)->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(type: .get, url: "/app/index", token: nil, parameters: nil, success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)),
                let homepage = try? HomePageTopModel(data: data) {
                success(homepage)
            }
        }, failure: { error in
            failure(error)
        })
    }

    static func getNews(page: Int, category: Int, success: @escaping (NewsTopModel)->(), failure: @escaping (Error)->()) {
        SolaSessionManager.solaSession(type: .get, url: "/news/\(category)/page/\(page)", token: nil, parameters: nil, success: { dic in
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.init(rawValue: 0)),
                let news = NewsTopModel(data: data) {
                success(news)
            }
        }, failure: { error in
            failure(error)
        })
    }

    static func getGallery(success: @escaping ([GalleryModel])->(), failure: @escaping (Error)->()) {
        if let galleries = try? Galleries(fromURL: URL(string: "https://www.twt.edu.cn/mapi/galleries/index")!) {
            success(galleries)
        } else {
            failure(WPYCustomError("请求出错"))
        }
    }
}
