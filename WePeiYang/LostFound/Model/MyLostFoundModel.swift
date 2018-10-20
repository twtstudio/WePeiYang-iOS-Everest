//
//  MyLostFoundModel.swift
//  WePeiYang
//
//  Created by JasonEWNL on 2018/10/20.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import Foundation

class MyLostFoundModel{
    
    var isBack = ""
    var title = ""
    var time = ""
    var place = ""
    var picture = ""
    var id = 0;
    var name = ""
    var phone = ""
    var detail_type = 0
    
    init(isBack: String,title: String, detail_type : Int, time: String, place: String, picture: String, id: Int, name: String, phone: String) {
        
        self.isBack = isBack
        self.title = title
        self.detail_type = detail_type
        self.time = time
        self.place = place
        self.picture = picture
        self.id = id
        self.name = name
        self.phone = phone
    }
}
