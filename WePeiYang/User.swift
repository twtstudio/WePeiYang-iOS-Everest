
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
    
    func getReviews(success: @escaping (Void)->(Void)) {
        getToken { token in
            var headers = HTTPHeaders()
            headers["User-Agent"] = DeviceStatus.userAgentString()
            headers["Authorization"] = "Bearer {\(token)}"
            var fooReviewList: [Review] = []
            Alamofire.request(ReadAPI.reviewURL, parameters: nil, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value,
                        let dict = value as? Dictionary<String, AnyObject>,
                        dict["error_code"] as! Int == -1,
                        let data = dict["data"] as? Array<NSDictionary> {
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
                            fooReviewList.append(Review(reviewID: reviewID, bookID: bookID, bookName: title, userName: username, avatarURL: avatar, rating: score, like: like, content: content, updateTime: updateTime, liked: liked))
                        }
                        self.reviews = fooReviewList
                        success()
                        return
                    }
                    // FIXME: errorMessage/ MsgDisplay
                // 评论提交失败
                case .failure(let error):
                    log.error(error)/
                    if let data = response.result.value as? Dictionary<String, AnyObject> {
                        // FIXME: errorMessage/ MsgDisplay
                        // 网络开小差啦
                        log.errorMessage(data["message"] as! String)/
                    }
                }
            }
        }
    }
    
    func getBookShelf(success: @escaping (Void)->(Void)) {
        getToken { token in
            var headers = HTTPHeaders()
            headers["User-Agent"] = DeviceStatus.userAgentString()
            headers["Authorization"] = "Bearer {\(token)}"
            Alamofire.request(ReadAPI.bookshelfURL, parameters: nil, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value,
                        let dict = value as? Dictionary<String, AnyObject>,
                        dict["error_code"] as! Int == -1,
                        let data = dict["data"] as? Array<NSDictionary> {
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
                        return
                    }
                    // FIXME: errorMessage/ MsgDisplay
                    // 获取收藏数据失败
                    log.errorMessage("获取收藏数据失败")/
                case .failure(let error):
                    log.error(error)/
                    if let data = response.result.value as? Dictionary<String, AnyObject> {
                        // FIXME: errorMessage/ MsgDisplay
                        // 网络开小差啦
                        log.errorMessage(data["message"] as! String)/
                    }
                }
            }

        }

    }
    
    func like(method: LikeMethod, reviewID: String, success: @escaping (Void)->(Void)) {
        getToken{ token in
            var headers = HTTPHeaders()
            headers["User-Agent"] = DeviceStatus.userAgentString()
            headers["Authorization"] = "Bearer {\(token)}"
            let url = method == .like ? ReadAPI.addLikeURL+reviewID : ReadAPI.resLikeURL+reviewID
            let msg = method == .like ? "点赞" : "取消"
            Alamofire.request(url, parameters: nil, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value,
                        let dict = value as? Dictionary<String, AnyObject>,
                        dict["error_code"] as! Int == -1 {
                        success()
                        // 为了解决从”我的“界面点赞之后进入我的评论列表不刷新的问题
                        for review in self.reviews {
                            if "\(review.reviewID)" == reviewID {
                                // like 1, cancel -1
                                review.like += method.rawValue
                                review.liked = true
                            }
                        }
                        return
                    }
                    // FIXME: errorMessage/ MsgDisplay
                    // 点赞成功失败
                    log.word(msg)/
                case .failure(let error):
                    log.error(error)/
                    if let data = response.result.value as? Dictionary<String, AnyObject> {
                        // FIXME: errorMessage/ MsgDisplay
                        // 网络开小差啦
                        log.errorMessage(data["message"] as! String)/
                    }
                }
            }
        }
    }

    func commitReview(content: String?, bookid: String, rating: Double, success: @escaping (Void)->(Void)) {
        getToken { token in
            if let content = content {
                let para = ["content": content, "id": bookid, "score": rating] as [String: Any]
                var headers = HTTPHeaders()
                headers["User-Agent"] = DeviceStatus.userAgentString()
                headers["Authorization"] = "Bearer {\(token)}"
                Alamofire.request(ReadAPI.commitReviewURL, method: .post, parameters: para, headers: headers).responseJSON { response in
                    switch response.result {
                    case .success:
                        if let value = response.result.value,
                            let dict = value as? Dictionary<String, AnyObject>,
                            dict["error_code"] as! Int == -1 {
                            success()
                            return
                        }
                        // FIXME: errorMessage/ MsgDisplay
                        // 评论提交失败
                    case .failure(let error):
                        log.error(error)/
                        if let data = response.result.value as? Dictionary<String, AnyObject> {
                            // FIXME: errorMessage/ MsgDisplay
                            // 网络开小差啦
                            log.errorMessage(data["message"] as! String)/
                        }
                    }
                }
            } else {  // 没有评论内容
                let para = ["id": bookid, "score": rating] as [String: Any]
                var headers = HTTPHeaders()
                headers["User-Agent"] = DeviceStatus.userAgentString()
                headers["Authorization"] = "Bearer {\(token)}"
                Alamofire.request(ReadAPI.scoreURL, method: .post, parameters: para, headers: headers).responseJSON { response in
                    switch response.result {
                    case .success:
                        if let value = response.result.value,
                            let dict = value as? Dictionary<String, AnyObject>,
                            dict["error_code"] as! Int == -1 {
                            success()
                            return
                        }
                        // FIXME: errorMessage/ MsgDisplay
                        // 提交失败
                    case .failure(let error):
                        log.error(error)/
                        if let data = response.result.value as? Dictionary<String, AnyObject> {
                            // FIXME: errorMessage/ MsgDisplay
                            // 网络开小差啦
                            log.errorMessage(data["message"] as! String)/
                        }
                    }
                }
            }
        }
    }
    
    func addFavorite(id: String, success: @escaping (Void)->(Void)) {
        getToken { token in
            var headers = HTTPHeaders()
            headers["User-Agent"] = DeviceStatus.userAgentString()
            headers["Authorization"] = "Bearer {\(token)}"
            let url = ReadAPI.addBookShelfURL + id
            Alamofire.request(url, parameters: nil, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value,
                        let dict = value as? Dictionary<String, AnyObject>,
                        dict["error_code"] as! Int == -1 {
                        success()
                        return
                    }
                    // FIXME: errorMessage/ MsgDisplay
                    // 添加失败
                case .failure(let error):
                    log.error(error)/
                    if let data = response.result.value as? Dictionary<String, AnyObject> {
                        // FIXME: errorMessage/ MsgDisplay
                        // 网络开小差啦
                        log.errorMessage(data["message"] as! String)/
                    }
                }
            }
        }
    }

    func delFavorite(id: String, success: @escaping (Void)->(Void)) {
        getToken { token in
            var headers = HTTPHeaders()
            headers["User-Agent"] = DeviceStatus.userAgentString()
            headers["Authorization"] = "Bearer {\(token)}"
            let url = ReadAPI.delBookShelfURL + id
            Alamofire.request(url, parameters: nil, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value,
                        let dict = value as? Dictionary<String, AnyObject>,
                        dict["error_code"] as! Int == -1 {
                        success()
                        return
                    }
                    // FIXME: errorMessage/ MsgDisplay
                    // 删除失败
                case .failure(let error):
                    log.error(error)/
                    if let data = response.result.value as? Dictionary<String, AnyObject> {
                        // FIXME: errorMessage/ MsgDisplay
                        // 网络开小差啦
                        log.errorMessage(data["message"] as! String)/
                    }
                }
            }
        }
    }
    
    func getToken(success: @escaping (String)->(Void)) {
        
        guard let token = AccountManager.token else {
            // FIXME: MsgDisplay
            // FIXME: LoginViewController
            return
        }
        
        if let readToken = UserDefaults.standard.object(forKey: READ_TOKEN_KEY) as? String {
            success(readToken)
        } else {
            var headers = HTTPHeaders()
            headers["User-Agent"] = DeviceStatus.userAgentString()
            headers["Authorization"] = "Bearer {\(token)}"
            Alamofire.request(ReadAPI.tokenURL+"?wpy_token=\(token)", parameters: nil, headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value,
                        let dict = value as? Dictionary<String, AnyObject>,
                        dict["error_code"] as! Int == -1,
                        let data = dict["data"] as? Dictionary<String, AnyObject>,
                        let readToken = data["token"] as? String {
                        UserDefaults.standard.set(readToken, forKey: READ_TOKEN_KEY)
                        success(readToken)
                    }
                case .failure(let error):
                    log.error(error)/
                    if let data = response.result.value as? Dictionary<String, AnyObject> {
                        // FIXME: errorMessage/ MsgDisplay
                        log.errorMessage(data["message"] as! String)/
                        // 网络开小差啦
                    }
                }
            }
        }
        
    }
    
}

