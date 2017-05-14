//
//  Book.swift
//  WePeiYang
//
//  Created by Allen X on 2016/10/25.
//  Modified by Halcao on 2017/4/8.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import Foundation

class Book {
    
    struct Status {
        let id: Int
        let barcode: String
        let callno: String
        let stateCode: Int
        let statusInLibrary: String
        let libCode: String
        let localCode: String
        let dueTime: String
        let library: String
    }
    
    let id: Int
    let title: String
    let ISBN: String
    let author: String
    let publisher: String
    let year: String
    let coverURL: String
    let rating: Double
    let summary: String
    let status: [Status]
    var reviews: [Review]
    let starReviews: [StarReview]
    
    init(id: Int, title: String, ISBN: String, author: String, publisher: String, year: String, coverURL: String, rating: Double, summary: String, status: [Status], reviews: [Review], starReviews: [StarReview]) {
        self.id = id
        self.title = title
        self.ISBN = ISBN
        self.author = author
        self.publisher = publisher
        self.year = year
        self.coverURL = coverURL
        self.rating = rating
        self.summary = summary
        self.status = status
        self.reviews = reviews
        self.starReviews = starReviews
    }
    
    init(ISBN: String) {
        self.id = 1
        self.ISBN = ISBN
        
        self.status = [Status(id: 23322, barcode: "0", callno: "0", stateCode: 1, statusInLibrary: "0", libCode: "1", localCode: "0", dueTime: "0", library: "0")]
        self.title = "人生的经验"
        self.coverURL = "https://images-na.ssl-images-amazon.com/images/I/51w6QuPzCLL._SX319_BO1,204,203,200_.jpg"
        self.author = "长者"
        self.publisher = "蛤蛤出版社"
        self.year = "1989 年"
        self.rating = 4.9
        self.summary = "有时候也要考虑历史的进程"
        
        self.reviews = [Review(reviewID: 0, bookID: 0, title: "大致是标题", username: "应该是用户名", avatarURL: "0.0.0.0", rating: 2.0, like: 2, content: "", updateTime: "1s后", liked: false)]
        
        
        self.starReviews = [StarReview(name: "⊂((・x・))⊃", content: "( ´▽｀)")]
    }
    
}
