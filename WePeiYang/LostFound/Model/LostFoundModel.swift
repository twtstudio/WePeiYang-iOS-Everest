//
//  File.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class LostFoundModel {
    
    var id = 0
    var detail_type = ""
    var time = ""
    var picture = ""
    var place = ""
    var title = ""
    var phone = ""
    var isback = ""
    var name = ""
    
    init(id: Int, title: String, detail_type: String, time: String, picture: String, place: String, phone: String, isback: String, name: String) {
    
        self.id = id
        self.title = title
        self.detail_type = detail_type
        self.time = time
        self.picture = picture
        self.place = place
        self.phone = phone
        self.isback = isback
        self.name = name
    }
    
}
