//
//  Review.swift
//  WePeiYang
//
//  Created by Halcao on 2017/4/7.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation

class Review {
    var reviewID = 0
    var bookID = 0
    var title = ""
    var username = ""
    var avatar = ""
    var score = 0.0
    var content = ""
    var updateTime = ""
    var liked = false
    var like = 0
    // reviewID: reviewID, bookID: bookID, bookName: title, userName: username, avatarURL: avatar, rating: score, like: like, content: content, updateTime: updateTime, liked: liked
    init(reviewID: Int, bookID: Int, title: String, username: String, avatarURL: String, rating: Double, like: Int, content: String, updateTime: String, liked: Bool) {
        self.reviewID = reviewID
        self.bookID = bookID
        self.title = title
        self.username = username
        self.avatar = avatarURL
        self.score = rating
        self.content = content
        self.updateTime = updateTime
        self.like = like
        self.liked = liked
        
    }
}

class StarReview {
    let name: String
    let content: String
    
    init(name: String, content: String) {
        self.name = name
        self.content = content
    }
}
