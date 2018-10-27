//
//  LostFoundModel.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

class LostFoundModel {
    
    var id = 0
    var detailType = 0
    var time = ""
    var picture = ""
    var place = ""
    var title = ""
    var phone = ""
    var isback = ""
    var name = ""
    
    init(id: Int, title: String, detailType: Int, time: String, picture: String, place: String, phone: String, isback: String, name: String) {
        self.id = id
        self.title = title
        self.detailType = detailType
        self.time = time
        self.picture = picture
        self.place = place
        self.phone = phone
        self.isback = isback
        self.name = name
    }
}
