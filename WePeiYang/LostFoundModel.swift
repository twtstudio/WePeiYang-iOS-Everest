//
//  File.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class LostFoundModel {
    
    var detail_type = 0
    var time = ""
    var picture = ""
    var place = ""
    var title = ""
    
    init(title: String, detail_type: Int, time: String, picture: String, place: String) {
        
        self.title = title
        self.detail_type = detail_type
        self.time = time
        self.picture = picture
        self.place = place
    }
    
}
