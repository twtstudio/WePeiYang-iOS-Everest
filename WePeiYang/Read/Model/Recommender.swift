//
//  Recommender.swift
//  WePeiYang
//
//  Created by JinHongxu on 2016/10/28.
//  Modified by Halcao on 2017/4/8.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation

class Recommender {
    
    var bannerList: [Banner] = []
    var recommendedList: [RecommendedBook] = []
    var starList: [StarUser] = []
    var reviewList: [Review] = []
    var finishFlag = FinishFlag()
    var dataDidRefresh = false
    
    static let sharedInstance = Recommender()
    private init() {}
    
    struct Banner {
        var image: String
        var title: String
        var url: String
    }
    
    struct RecommendedBook {
        var id: Int
        var title: String
        var author: String
        var cover: String
    }
    
    struct StarUser {
        var id: Int
        var name: String
        var avatar: String
        var reviewCount: Int
    }
    
    struct FinishFlag {
        var bannerFlag = false
        var recommendedFlag = false
        var hotReviewFlag = false
        var starUserFlag = false
        
        func isFinished() -> Bool {
            return bannerFlag && recommendedFlag && hotReviewFlag && starUserFlag
        }
        
        mutating func reset() {
            bannerFlag = false
            recommendedFlag = false
            hotReviewFlag = false
            starUserFlag = false
        }
    }
    
    func getBannerList(success: @escaping () -> ()) {
        var fooBannerList: [Banner] = []
        ReadBeacon.request(ReadAPI.bannerURL ,failureMessage: "获取数据失败", failure: { dict in
            guard dict["error_code"] as! Int != 10000 else {
                print("removed read token")
                UserDefaults.standard.removeObject(forKey: READ_TOKEN_KEY)
                return
                // FIXME: token should be refreshed??
            }
            self.finishFlag.bannerFlag = true
            // FIXME: MsgDisplay
            // MsgDisplay.showErrorMsg("获取 banner 数据失败")
        }) { dict in
            if let data = dict["data"] as? Array<NSDictionary> {
                for dic in data {
                    guard let image = dic["img"] as? String,
                        let title = dic["title"] as? String,
                        let url = dic["url"] as? String
                        else {
                            continue
                    }
                    fooBannerList.append(Banner(image: image, title: title, url: url))
                }
                self.finishFlag.bannerFlag = true
                self.bannerList = fooBannerList
                success()
            }
        }
    }
    
    func getRecommendedList(success: @escaping () -> ()) {
        var fooRecommendedList: [RecommendedBook] = []
        ReadBeacon.request(ReadAPI.recommendedURL ,failureMessage: "获取数据失败", failure: { dict in
            self.finishFlag.recommendedFlag = true
            // FIXME: MsgDisplay
            // MsgDisplay.showErrorMsg("获取热门推荐数据失败")
        }) { dict in
            if let data = dict["data"] as? Array<NSDictionary> {
                for dic in data {
                    guard let id = dic["id"] as? Int,
                        let title = dic["title"] as? String,
                        let author = dic["author"] as? String,
                        let cover = dic["cover_url"] as? String
                        else {
                            continue
                    }
                    fooRecommendedList.append(RecommendedBook(id: id, title: title, author: author, cover: cover))
                }
                self.finishFlag.recommendedFlag = true
                self.recommendedList = fooRecommendedList
                success()
            }
        }
    }
    
    func getStarUserList(success: @escaping () -> ()) {
        var fooStarList: [StarUser] = []
        ReadBeacon.request(ReadAPI.starUserURL ,failureMessage: "获取数据失败", failure: { dict in
            self.finishFlag.starUserFlag = true
            // FIXME: MsgDisplay
            // MsgDisplay.showErrorMsg("获取阅读之星数据失败")
        }) { dict in
            if let data = dict["data"] as? Array<NSDictionary> {
                for dic in data {
                    guard let id = dic["twtid"] as? Int,
                        let name = dic["twtuname"] as? String,
                        let avatar = dic["avatar"] as? String,
                        let reviewCount = dic["review_count"] as? Int
                        else {
                            continue
                    }
                    fooStarList.append(StarUser(id: id, name: name, avatar: avatar, reviewCount: reviewCount))
                    
                }
                self.finishFlag.starUserFlag = true
                self.starList = fooStarList
                success()
            }
        }
    }
    
    func getHotReviewList(success: @escaping () -> ()) {
        var fooReviewList: [Review] = []
        ReadBeacon.request(ReadAPI.hotReviewURL ,failureMessage: "获取数据失败", failure: { dict in
            self.finishFlag.hotReviewFlag = true
            // FIXME: MsgDisplay
            // MsgDisplay.showErrorMsg("获取热门评论数据失败")
        }) { dict in
            if let data = dict["data"] as? Array<NSDictionary> {
                for dic in data {
                    guard let reviewID = dic["review_id"] as? Int,
                        let bookID = dic["book_id"] as? Int,
                        let title = dic["title"] as? String,
                        let username = dic["user_name"] as? String,
                        let avatar = dic["avatar"] as? String,
                        let score = dic["score"] as? Double,
                        let like = dic["like_count"] as? Int,
                        let content = dic["content"] as? String,
                        let updateTime = dic["updated_at"] as? String,
                        let liked = dic["liked"] as? Bool
                        else {
                            continue
                    }
                    fooReviewList.append(Review(reviewID: reviewID, bookID: bookID, title: title, username: username, avatarURL: avatar, rating: score, like: like, content: content, updateTime: updateTime, liked: liked))
                }
                self.finishFlag.hotReviewFlag = true
                self.reviewList = fooReviewList
                success()
            }
        }
    }
}

