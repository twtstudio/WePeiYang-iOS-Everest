
//
//  Librarian.swift
//  WePeiYang
//
//  Created by Allen X on 16/10/27.
//  Modified by Halcao on 2017/4/7.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation


struct Librarian {
    struct SearchResult {
        let title: String
        //优化，此时得到的一些信息，特别是 cover 的图片可以在详情页面复用
        let coverURL: String
        let author: String
        let publisher: String
        let year: String
        let rating: Double
        let bookID: Int
        let ISBN: String
    }
    
    static func search(string str: String, completion: @escaping ([SearchResult])->()) {
        guard let searchURL =  (ReadAPI.bookSearchURL + str).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            // FIXME: MsgDisplay URL错误
            completion([SearchResult]())
            return
        }
        log.word(searchURL)/
        // FIXME: Start loading
        ReadBeacon.request(searchURL, failureMessage: "哎呀，出错啦") { dict in
            guard let fooBooksResults = dict["data"] as? Array<NSDictionary> else {
                completion([SearchResult]())
                return
            }
            
            let foo = fooBooksResults.flatMap({ (dict: NSDictionary) -> SearchResult? in
                guard let title = dict["title"] as? String,
                    //let coverURL = dict["cover"] as? String,
                    let author = dict["author"] as? String,
                    let publisher = dict["publisher"] as? String,
                    let year = dict["year"] as? String,
                    //let rating = dict["rating"] as? Double,
                    let bookID = dict["index"] as? String,
                    let ISBN = dict["isbn"] as? String
                    else {
                        // FIXME: MsgDisplay.showErrorMsg("未知错误2")
                        log.word("未知错误")/
                        return nil
                }
                
                var coverURL = "https://images-na.ssl-images-amazon.com/images/I/51w6QuPzCLL._SX319_BO1,204,203,200_.jpg"
                if let foo = dict["cover"] as? String {
                    coverURL = foo
                }
                
                var rating: Double = 3.0
                if let foo = dict["rating"] as? Double {
                    rating = foo
                }
                // FIXME: bookID到底是String还是Int
                return SearchResult(title: title, coverURL: coverURL, author: author, publisher: publisher, year: year, rating: rating, bookID: Int(bookID)!, ISBN: ISBN)
            })
            // FIXME: Loading dismiss
            completion(foo)
        }
    }
    
    static func getBookDetail(withID id: String, completion: @escaping (Book)->()) {
        let bookDetailURL = ReadAPI.bookDetailURL + "\(id)?include=review,starreview,holding"
        ReadBeacon.request(bookDetailURL, failureMessage: "哎呀，出错啦") { dict in
            guard let fooDetail = dict["data"] as? NSDictionary else {
                // FIXME: MsgDisplay 错误
                return
            }
            guard let id = fooDetail["id"] as? Int,
                let title = fooDetail["title"] as? String,
                let ISBN = fooDetail["isbn"] as? String,
                let author = fooDetail["author"] as? String,
                let publisher = fooDetail["publisher"] as? String,
                let year = fooDetail["time"] as? String,
                //let coverURL = fooDetail["cover_url"] as? String,
                //let rating = fooDetail["rating"] as? Double,
                //let index = fooDetail["index"] as? String,
                let reviewData = fooDetail["review"] as? NSDictionary,
                let starReviewData = fooDetail["starreview"] as? NSDictionary,
                let summary = fooDetail["summary"] as? String,
                let holdingStatusData = fooDetail["holding"] as? NSDictionary else {
                    // FIXME: MsgDisplay 错误2
                    // MsgDisplay.showErrorMsg("未知错误2")
                    log.word("Unknown Error2")/
                    return
            }
            //Default cover
            var coverURL = "https://images-na.ssl-images-amazon.com/images/I/51w6QuPzCLL._SX319_BO1,204,203,200_.jpg"
            if let foo = fooDetail["cover_url"] as? String {
                coverURL = foo
            }
            //Default rating
            var rating = 3.0
            if let foo = fooDetail["rating"] as? Double {
                rating = foo
            }
            
            var fooHoldingStatus: [Book.Status] = []
            if let holdingStatus = holdingStatusData["data"] as? Array<NSDictionary> {
                //                        log.obj(holdingStatus)/
                fooHoldingStatus = holdingStatus.flatMap({ (dict: NSDictionary) -> Book.Status? in
                    guard let id = dict["id"] as? Int,
                        let barcode = dict["barcode"] as? String,
                        let callno = dict["callno"] as? String,
                        let stateCode = dict["stateCode"] as? Int,
                        let state = dict["state"] as? String,
                        let statusInLibrary = dict["state"] as? String,
                        let libCode = dict["libCode"] as? String,
                        let localCode = dict["localCode"] as? String,
                        let dueTime = dict["indate"] as? String,
                        let library = dict["local"] as? String
                        else {
                            // FIXME: MsgDisplay 错误3
                            // MsgDisplay.showErrorMsg("未知错误3")
                            log.word("Unknown Error3")/
                            return nil
                    }
                    //return nil
                    // FIXME: State???
                    log.word(state)/
                    return Book.Status(id: id, barcode: barcode, callno: callno, stateCode: stateCode, statusInLibrary: statusInLibrary, libCode: libCode, localCode: localCode, dueTime: dueTime, library: library)
                })
                
            }
            
            var fooReviews: [Review] = []
            if let reviews = reviewData["data"] as? Array<NSDictionary> {
                
                fooReviews = reviews.flatMap({ (dict: NSDictionary) -> Review? in
                    guard let reviewID = dict["review_id"] as? Int,
                        let bookID = dict["book_id"] as? Int,
                        let bookName = dict["title"] as? String,
                        let userName = dict["user_name"] as? String,
                        let avatarURL = dict["avatar"] as? String,
                        let rating = dict["score"] as? Double,
                        let like = dict["like_count"] as? Int,
                        let content = dict["content"] as? String,
                        let updateTime = dict["updated_at"] as? String,
                        //TODO: liked as Bool may fail
                        let liked = dict["liked"] as? Bool else {
                            // FIXME: MsgDisplay 错误3
                            // MsgDisplay.showErrorMsg("未知错误")
                            log.word("Unknown Error5")/
                            return nil
                    }
                    log.word(content)/
                    return Review(reviewID: reviewID, bookID: bookID, title: bookName, username: userName, avatarURL: avatarURL, rating: rating, like: like, content: content, updateTime: updateTime, liked: liked)
                })
            }

            var fooStarReviews: [StarReview] = []
            
            if let star_reviews = starReviewData["data"] as? Array<NSDictionary> {
                fooStarReviews = star_reviews.flatMap({ (dict: NSDictionary) -> StarReview? in
                    guard let name = dict["name"] as? String,
                        let content = dict["content"] as? String else {
                            return nil
                    }
                    return StarReview(name: name, content: content)
                })
            }
            // 评论按时间倒序
            let reviewReversed: [Review] = fooReviews.reversed()
            let foo = Book(id: id, title: title, ISBN: ISBN, author: author, publisher: publisher, year: year, coverURL: coverURL, rating: rating, summary: summary, status: fooHoldingStatus, reviews: reviewReversed, starReviews: fooStarReviews)
            completion(foo)

        }
    }
}
