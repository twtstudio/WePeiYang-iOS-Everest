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
            } else {
                failure(WPYCustomError.custom("Banner 数据解析错误"))
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
            } else {
                failure(WPYCustomError.custom("新闻数据解析错误"))
            }
        }, failure: { error in
            failure(error)
        })
    }

    static func getGallery(success: @escaping ([GalleryModel])->(), failure: @escaping (Error)->()) {
        let queue = DispatchQueue(label: "\(Date().description)+gallery")
        queue.async {
            if let galleries = try? Galleries(fromURL: URL(string: "https://www.twt.edu.cn/mapi/galleries/index")!) {
                DispatchQueue.main.async {
                    success(galleries)
                }
            } else {
                DispatchQueue.main.async {
                    failure(WPYCustomError.custom("图集请求出错"))
                }
            }
        }
    }
}
