
//
//  ReadAPI.swift
//  WePeiYang
//
//  Created by Halcao on 2017/4/7.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation

struct ReadAPI {
    static let baseURL = "https://book.twtstudio.com/api/"
    static let baseURL1 = "http://takooctopus.com/yuepeiyang/public/api/"
    static let bannerURL = baseURL + "banner/5"
    static let recommendedURL = baseURL + "recommended/6"
    static let hotReviewURL = baseURL + "hotreview/3"
    static let starUserURL = baseURL + "starreader/3"
    static let tokenURL = baseURL + "auth/token/get"
    static let addLikeURL = baseURL + "review/addlike/"
    static let resLikeURL = baseURL + "review/reslike/"
    static let reviewURL = baseURL + "review/get"
    static let bookSearchURL = baseURL + "book/search/"
    static let bookDetailURL = baseURL + "book/detail/"
    static let addBookShelfURL = baseURL + "book/addbookshelf/"
    static let commitReviewURL = baseURL + "book/review"
    static let bookshelfURL = baseURL + "book/bookshelf/get"
    static let scoreURL = baseURL + "book/score"
    static let delBookShelfURL = baseURL + "book/delbookshelf/"
}
