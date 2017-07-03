//
//  File.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class LostFoundDetailModel {
    var id = 0
    var name = ""
    var title = ""
    var place = ""
    var phone = 0
    var isback = ""
    var picture = ""
    
    init(id: Int, name: String, title: String, place: String, phone: Int, isback: String, picture: String) {
        self.id = id
        self.name = name
        self.title = title
        self.place = place
        self.phone = phone
        self.isback = isback
        self.picture = picture
    }
}
