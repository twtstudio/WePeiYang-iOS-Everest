
//
//  User.swift
//  WePeiYang
//
//  Created by Halcao on 2017/4/7.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit
import Alamofire

enum LikeMethod: Int {
    case like = 1
    case cancel = -1
}

let READ_TOKEN_KEY = "readToken"

class User {
    var username: String = "null"
    var bookShelf = [MyBook]() // 我的收藏
    var reviews = [Review]() // 我的点评
    var avatar: String! // 头像url
    var id: Int!

    static let shared: User = User()
    private init() {}
    
    func getReviews(success: @escaping ()->()) {
        var fooReviewList: [Review] = []
        ReadBeacon.request(ReadAPI.reviewURL, failureMessage: "评论提交失败") { dict in
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
                self.reviews = fooReviewList
                success()
            }
        }
    }
    
    func getBookShelf(success: @escaping ()->()) {
        ReadBeacon.request(ReadAPI.bookshelfURL, failureMessage: "获取收藏数据失败") { dict in
            if let data = dict["data"] as? Array<NSDictionary> {
                for dic in data {
                    guard let book_id = dic["book_id"] as? Int,
                        let title = dic["title"] as? String,
                        let author = dic["author"] as? String
                        else {
                            continue
                    }
                    let book: MyBook = MyBook(title: title, author: author, id: book_id)
                    self.bookShelf.append(book)
                }
                success()
            }
        }
    }
    
    func like(method: LikeMethod, reviewID: String, success: @escaping ()->()) {
        let url = method == .like ? ReadAPI.addLikeURL+reviewID : ReadAPI.resLikeURL+reviewID
        let msg = method == .like ? "点赞" : "取消"
        ReadBeacon.request(url, failureMessage: msg+"失败") { dict in
            success()
            // 为了解决从”我的“界面点赞之后进入我的评论列表不刷新的问题
            for review in self.reviews {
                if "\(review.reviewID)" == reviewID {
                    // like 1, cancel -1
                    review.like += method.rawValue
                    review.liked = true
                }
            }
        }
    }

    func commitReview(content: String?, bookid: String, rating: Double, success: @escaping ()->()) {
        if let content = content {
            let para = ["content": content, "id": bookid, "score": rating] as [String: Any]
            ReadBeacon.request(ReadAPI.commitReviewURL, method: .post, parameters: para, failureMessage: "评论失败") { dict in
                success()
            }
        } else {  // 没有评论内容
            let para = ["id": bookid, "score": rating] as [String: Any]
            ReadBeacon.request(ReadAPI.commitReviewURL, method: .post, parameters: para, failureMessage: "评分失败") { dict in
                success()
            }
        }
    }

    func addFavorite(id: String, success: @escaping ()->()) {
        let url = ReadAPI.addBookShelfURL + id
        ReadBeacon.request(url, failureMessage: "添加失败") { dict in
            success()
        }
    }

    func delFavorite(id: String, success: @escaping ()->()) {
        let url = ReadAPI.delBookShelfURL + id
        ReadBeacon.request(url, failureMessage: "删除失败") { dict in
            success()
        }
    }
    
    func getToken(success: @escaping (String)->()) {
        
        guard let token = TwTUser.shared.token else {
            // FIXME: MsgDisplay
            // FIXME: LoginViewController
            return
        }
        
        if let readToken = UserDefaults.standard.object(forKey: READ_TOKEN_KEY) as? String {
            success(readToken)
        } else {
            var headers = HTTPHeaders()
            headers["User-Agent"] = DeviceStatus.userAgent
            headers["Authorization"] = "Bearer \(token)"
            
            SolaSessionManager.solaSession(type: .get, baseURL: ReadAPI.tokenURL, url: "?wpy_token=\(token)", parameters: nil, success: { dict in
                if let data = dict["data"] as? Dictionary<String, AnyObject>,
                    let readToken = data["token"] as? String {
                    UserDefaults.standard.set(readToken, forKey: READ_TOKEN_KEY)
                    success(readToken)
                }
            }, failure: { error in
                log.error(error)/
////                if let data = response.result.value as? Dictionary<String, AnyObject> {
//                    // FIXME: errorMessage/ MsgDisplay
//                    log.errorMessage(data["message"] as! String)/
//                    // 网络开小差啦
//                }
            })
        }
        
    }
    
}

