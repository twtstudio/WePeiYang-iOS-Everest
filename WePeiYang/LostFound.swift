//
//  File.swift
//  WePeiYang
//
//  Created by Hado on 2017/7/3.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class LostFoundModel {
    
    var name = ""
    var time = ""
    var picture = ""
    var place = ""
    var title = ""
    
    init(title: String, name: String, time: String, picture: String, place: String) {
        
        self.title = title
        self.name = name
        self.time = time
        self.picture = picture
        self.place = place
    }
    
}
