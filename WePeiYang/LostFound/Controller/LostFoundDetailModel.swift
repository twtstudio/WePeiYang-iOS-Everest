//
//  File.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class LostFoundDetailModel {
    var id = ""
    var name = ""
    var title = ""
    var place = ""
    var phone = ""
    var time = ""
    var picture = ""
    var item_description = "" //介绍
    var detail_type = 0
    var card_name = ""
    var card_number = 0
    var publish_start = ""
    var publish_end = ""
    var other_tag = ""
    var type = 0
    
    
    init(id: String, name: String, title: String, place: String, phone: String, time: String, picture: String, item_description: String, card_name: String, card_number: Int, publish_start: String, publish_end: String, other_tag: String, type: Int, detail_type: Int) {
        self.id = id
        self.name = name
        self.title = title
        self.place = place
        self.phone = phone
        self.time = time
        self.picture = picture
        self.item_description = item_description
        self.card_name = card_name
        self.card_number = card_number
        self.publish_start = publish_start
        self.publish_end = publish_end
        self.other_tag = other_tag
        self.type = type
        
    }
}
